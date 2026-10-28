//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

class DefaultAuthService: AuthService {
    private let supabase = SupabaseManager.shared.client
    private var auth: AuthClient { supabase.auth }
    let resendIntervalSec: Double = 60
    
    private var subscribers: [String: AsyncStream<AuthState>.Continuation] = [:]
    private var authListenerTask: Task<Void, Never>?
    private var accountStateListenerTask: Task<Void, Never>?
    private var lastAuthState: AuthState?
    private var currentAuthSession: AuthSession? {
        switch lastAuthState {
        case .authenticated(let session): session
        default: nil
        }
    }
    private var passwordRecovery: Bool = false
    private var accountStateRealtimeHub: SupabaseManager.SupabaseRealtimeHub?
    
    func signUp(email: String, password: String, fullName: String, redirectTo url: URL?) async throws {
        let userData = SupabaseManager.Authentication.User.self
        
        do {
            let data: [String: AnyJSON] = [
                userData.name: .string(fullName),
            ]
            try await auth.signUp(email: email, password: password, data: data, redirectTo: url)
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func handle(url: URL, passwordReset: Bool) async throws {
        passwordRecovery = passwordReset
        auth.handle(url)
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(email: email, password: password)
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func signOut() async throws {
        try? await auth.signOut()
    }
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {
        do {
            try await auth.resetPasswordForEmail(email, redirectTo: url)
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func resetPassword(newPassword: String) async throws {
        do {
            let userAttributes = UserAttributes(password: newPassword)
            try await auth.update(user: userAttributes)
            if let currentAuthSession {
                publish(.authenticated(currentAuthSession))
            }
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func signInWithCredential(_ credential: OAuthCredential) async throws {
        do {
            try await auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: credential.provider.supabaseProvider,
                    idToken: credential.idToken,
                    accessToken: credential.accessToken,
                    nonce: credential.nonce
                )
            )
            
            if let fullName = credential.fullName {
                try await updateUserData(fullName: fullName)
            }
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    private func updateUserData(fullName: String) async throws {
        let fullNameKey = SupabaseManager.Authentication.User.name
        
        do {
            try await auth.update(
                user: UserAttributes(
                    data: [fullNameKey: .string(fullName)]
                )
            )
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
}


// MARK: - Auth events
extension DefaultAuthService {
    func authStateStream() async -> AsyncStream<AuthState> {
        let id = UUID().uuidString
        let (stream, continuation) = AsyncStream.makeStream(of: AuthState.self, bufferingPolicy: .bufferingNewest(1))
        subscribers[id] = continuation
        continuation.onTermination = { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in self.subscribers[id] = nil }
        }
        if let lastAuthState { continuation.yield(lastAuthState) }
        
        startListeningToAuthChangesIfNeeded()
        
        return stream
    }
    
    private func startListeningToAuthChangesIfNeeded() {
        guard authListenerTask == nil else { return }
        
        let changes = auth.authStateChanges
        authListenerTask = Task { [weak self] in
            for await (event, session) in changes {
                await self?.handleAuthState(event: event, session: session)
            }
        }
    }
    
    private func handleAuthState(event: AuthChangeEvent, session: Session?) async {
        switch event {
        case .initialSession, .signedIn:
            guard let session, !session.isExpired else {
                stopListeningToAccountStateChanges()
                publish(.non)
                return
            }
            do {
                let authSession = try await makeAuthSession(session)
                if passwordRecovery {
                    passwordRecovery = false
                    publish(.passwordReset)
                } else if case .authenticated = lastAuthState {
                    break   // Already authenticated
                } else {
                    publish(.authenticated(authSession))
                    await startListeningToAccountStateChangesIfNeeded(userId: session.user.id.uuidString)
                }
                
            } catch {
                stopListeningToAccountStateChanges()
                publish(.failed(error))
            }
            
        case .passwordRecovery:
            passwordRecovery = false
            if case .passwordReset = lastAuthState { return }
            publish(.passwordReset)
            
        case .userUpdated:
            guard let session, let currentAuthSession else { return }
            let authSession = AuthSession(
                user: AppUser(from: session.user),
                accountState: currentAuthSession.accountState
            )
            if currentAuthSession != authSession { publish(.authenticated(authSession)) }
            
        case .signedOut:
            passwordRecovery = false
            stopListeningToAccountStateChanges()
            publish(.signedOut)
            
        default:
            break
        }
    }
    
    private func publish(_ state: AuthState) {
        subscribers.values.forEach { continuation in
            continuation.yield(state)
        }
        if case .failed = state {
            lastAuthState = nil
        } else {
            lastAuthState = state
        }
    }
    
    // MARK: Subscribing to account state changes
    private func startListeningToAccountStateChangesIfNeeded(userId: String) async {
        guard accountStateListenerTask == nil else { return }
        
        let realtimeHub = SupabaseManager.SupabaseRealtimeHub(
            channelName: "account_state",
            realtimeTables: RealtimeTable(
                tableName: SupabaseManager.Database.Table.ownerApplication.name,
                filter: .eq(SupabaseManager.Database.Table.ownerApplication.Column.applicantId, value: userId)
            ),
            RealtimeTable(
                tableName: SupabaseManager.Database.Table.PharmacyStaff.name,
                filter: .eq(SupabaseManager.Database.Table.PharmacyStaff.Column.userId, value: userId)
            ),
        )
        
        guard let accountStateStream = try? await realtimeHub.subscribeToChanges() else { return }
        accountStateRealtimeHub = realtimeHub
        accountStateListenerTask = Task { [weak self] in
            for await _ in  accountStateStream {
                await self?.handleAccountState()
            }
        }
    }
    
    private func stopListeningToAccountStateChanges() {
        accountStateListenerTask?.cancel()
        accountStateListenerTask = nil
        accountStateRealtimeHub = nil
    }
    
    private func handleAccountState() async  {
        guard let session = auth.currentSession, !session.isExpired,
              case .authenticated = lastAuthState, !passwordRecovery else { return }
        if let authSession = try? await makeAuthSession(session) {
            publish(.authenticated(authSession))
        }
    }
    
    // MARK: Supabase-RPC get account state
    private func makeAuthSession(_ session: Session) async throws -> AuthSession {
        let user = AppUser(from: session.user)
        let accountState = try await getAccountState()
        return AuthSession(user: user, accountState: accountState)
    }
    
    private func getAccountState() async throws -> AccountState {
        let getPharmacyStaffMemberByUserIdFunc = SupabaseManager.Database.Functions.getMyAccountState.self
        
        do {
            let pharmacyStaff: AccountState = try await supabase
                .rpc(getPharmacyStaffMemberByUserIdFunc.name)
                .execute()
                .value
            
            return pharmacyStaff
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

extension OAuthProvider {
    var supabaseProvider: OpenIDConnectCredentials.Provider {
        switch self {
        case .google: .google
        case .apple: .apple
        }
    }
}

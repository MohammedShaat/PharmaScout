//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

class DefaultAuthService: AuthService {
    let resendIntervalSec: Double = 60
    lazy var authState: AsyncStream<AuthState> = {
        authChangesStream()
    }()
    private(set) var authSession: AuthSession?

    private let supabase = SupabaseManager.shared.client
    private var auth: AuthClient { supabase.auth }
    private var passwordRecovery: Bool = false
    
    func signUp(email: String, password: String, redirectTo url: URL?) async throws {
        do {
            try await auth.signUp(email: email, password: password, redirectTo: url)
            
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
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func getUser() async throws -> AppUser {
        do {
            let user = try await auth.user()
            return AppUser(from: user)
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    func refreshAuthSession() async throws {
        do {
            let session = try await auth.session
            authSession = try await makeAuthSession(session)
            
        } catch {
            throw SupabaseErrorMapper.mapAuthError(error)
        }
    }
    
    private func getPharmacyStaffIfAvailable(userId: String) async throws -> PharmacyStaffMember? {
        let getPharmacyStaffMemberByUserIdFunc = SupabaseManager.Database.Functions.getPharmacyStaffMemberByUserId.self
        let params = getPharmacyStaffMemberByUserIdFunc.Params.self
        
        do {
            let pharmacyStaff: PharmacyStaffMember? = try await supabase
                .rpc(
                    getPharmacyStaffMemberByUserIdFunc.name,
                    params: [params.userId: userId]
                )
                .maybeSingle()
                .execute()
                .value
            
            return pharmacyStaff
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    private func makeAuthSession(_ session: Session) async throws -> AuthSession {
        let user = AppUser(from: session.user)
        let pharmacyStaff = try await getPharmacyStaffIfAvailable(userId: user.id)
        let role: UserRole = pharmacyStaff != nil ? .pharmacist : .patient
        
        return AuthSession(user: user, role: role, pharmacyStaff: pharmacyStaff)
    }
}

extension DefaultAuthService {
    func authChangesStream() -> AsyncStream<AuthState> {
        AsyncStream { continuation in
            Task {
                for await (event, session) in auth.authStateChanges {
                    switch event {
                        
                    // Start (authenticated or non-authenticated)
                    case .initialSession, .signedIn:
                        guard let session else {
                            authSession = nil
                            continuation.yield(.non)
                            continue
                        }
                        
                        do {
                            authSession = try await makeAuthSession(session)
                            
                            if passwordRecovery {
                                continuation.yield(.passwordReset)
                                passwordRecovery = false
                            } else {
                                continuation.yield(.authenticated)
                            }
                            
                        } catch {
                            authSession = nil
                            continuation.yield(.failed(error))
                        }
                        
                        
                    // Password reset
                    case .passwordRecovery:
                        continuation.yield(.passwordReset)

                    // Sign out
                    case .signedOut:
                        authSession = nil
                        continuation.yield(.non)
                        
                    default:
                        continue
                    }
                }
            }
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

extension AppUser {
    init(from user: User) {
        self.id = user.id.uuidString.lowercased()
        self.fullName = user.userMetadata["full_name"]?.stringValue
        self.email = user.email
    }
}

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

    private let auth = SupabaseManager.shared.client.auth
    private var passwordRecovery: Bool = false
    
    func signUp(email: String, password: String, redirectTo url: URL?) async throws {
        do {
            try await auth.signUp(email: email, password: password, redirectTo: url)
            
        } catch {
            throw mapError(error)
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
            throw mapError(error)
        }
    }
    
    func signOut() async throws {
        try? await auth.signOut()
    }
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {
        do {
            try await auth.resetPasswordForEmail(email, redirectTo: url)
            
        } catch {
            throw mapError(error)
        }
    }
    
    func resetPassword(newPassword: String) async throws {
        do {
            let userAttributes = UserAttributes(password: newPassword)
            try await auth.update(user: userAttributes)
            
        } catch {
            throw mapError(error)
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
            throw mapError(error)
        }
    }
    
    func getUser() async throws -> AppUser {
        do {
            let user = try await auth.user()
            return AppUser(from: user)
            
        } catch {
            throw mapError(error)
        }
    }
}

extension DefaultAuthService {
    func authChangesStream() -> AsyncStream<AuthState> {
        AsyncStream { continuation in
            Task {
                for await (event, session) in auth.authStateChanges {
                    switch event {
                    case .initialSession:
                        if session?.user != nil {
                            continuation.yield(.authenticated)
                        } else {
                            continuation.yield(.non)
                        }
                        
                    case .signedIn:
                        if session?.user != nil {
                            if passwordRecovery {
                                continuation.yield(.passwordReset)
                                passwordRecovery = false
                            } else {
                                continuation.yield(.authenticated)
                            }
                        }
                        
                    case .signedOut:
                        continuation.yield(.non)
                        
                    case .passwordRecovery:
                        continuation.yield(.passwordReset)
                        
                    default:
                        continue
                    }
                    
                    print("authState: ", event)
                }
            }
        }
    }
}

extension DefaultAuthService {
    private func mapError(_ error: Error) -> Error {
        switch error {
        case let authError as AuthError:
            mapAuthErrorToAppError(authError)
            
        case let urlError as URLError:
            NetworkError.init(from: urlError)
            
        default:
            error
        }
    }
    
    private func mapAuthErrorToAppError(_ error: AuthError) -> AppAuthError {
        switch error.errorCode {
        case .emailExists: .emailAlreadyExists
            
        case .weakPassword: .weakPassword
            
        case .overEmailSendRateLimit: .emailRateLimit
            
        case .emailNotConfirmed: .emailNotConfirmed
            
        case .invalidCredentials: .invalidCredentials
            
        case .overRequestRateLimit: .overRequestRateLimit
            
        case .samePassword: .samePassword
            
        default: .unknown(error)
            
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
        self.fullName = user.userMetadata["full_name"]?.stringValue
        self.email = user.email
    }
}

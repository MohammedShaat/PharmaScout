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
    
    func signUp(email: String, password: String, redirectTo url: URL?) async throws -> AppUser {
        do {
            let authResponse = try await auth.signUp(email: email, password: password, redirectTo: url)
            
            guard let email = authResponse.user.email else {
                throw AppAuthError.missingEmail
            }

            return AppUser(email: email)
            
        } catch let authError as AuthError {
            throw mapAuthErrorToAppError(authError)
            
        } catch let urlError as URLError {
            throw NetworkError.init(from: urlError)
        }
    }
    
    func handle(url: URL, passwordReset: Bool) async throws {
        passwordRecovery = passwordReset
        auth.handle(url)
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(email: email, password: password)
            
        } catch let authError as AuthError {
            throw mapAuthErrorToAppError(authError)
            
        } catch let urlError as URLError {
            throw NetworkError.init(from: urlError)
        }
    }
    
    func signOut() async throws {
        try? await auth.signOut()
    }
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {
        do {
            try await auth.resetPasswordForEmail(email, redirectTo: url)
            
            
        } catch let authError as AuthError {
            throw mapAuthErrorToAppError(authError)
            
        } catch let urlError as URLError {
            throw NetworkError.init(from: urlError)
        }
    }
    
    func resetPassword(newPassword: String) async throws {
        do {
            let userAttributes = UserAttributes(password: newPassword)
            try await auth.update(user: userAttributes)
            
        } catch let authError as AuthError {
            throw mapAuthErrorToAppError(authError)
            
        } catch let urlError as URLError {
            throw NetworkError.init(from: urlError)
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
            
        } catch let authError as AuthError {
            throw mapAuthErrorToAppError(authError)
            
        } catch let urlError as URLError {
            throw NetworkError.init(from: urlError)
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

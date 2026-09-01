//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct DefaultAuthService: AuthService {
    private let auth = SupabaseManager.shared.client.auth
    
    let authState: AsyncStream<AuthState>
    
    init() {
        authState = Self.authChangesStream(authClient: auth)
    }
    
    func signUp(email: String, password: String) async throws -> AppUser {
        do {
            let url = DeepLink.emailConfirmation.url
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
    
    func handle(url: URL) {
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
}

extension DefaultAuthService {
    static func authChangesStream(authClient: AuthClient) -> AsyncStream<AuthState> {
        AsyncStream { continuation in
            Task {
                for await (event, session) in authClient.authStateChanges {
                    switch event {
                    case .initialSession:
                        if session?.user != nil {
                            continuation.yield(.authenticated)
                        } else {
                            continuation.yield(.non)
                        }
                        
                    case .signedIn:
                        if session?.user != nil {
                            continuation.yield(.authenticated)
                        }
                        
                    case .signedOut:
                        continuation.yield(.non)
                        
                    default:
                        continue
                    }
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
            
        default: .unknown(error)
            
        }
    }
}

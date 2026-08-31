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
                throw SignUpError.missingEmail
            }

            return AppUser(email: email)
            
        } catch let authError as AuthError {
            switch authError.errorCode {
            case .emailExists: throw SignUpError.emailAlreadyExists
            case .weakPassword: throw SignUpError.weakPassword
            case .overEmailSendRateLimit: throw SignUpError.emailRateLimit
            default: throw SignUpError.unknown(authError)
            }
            
        } catch let urlError as URLError {
            throw NetworkError.mapURLError(urlError)
        }
    }
    
    func handle(url: URL) {
        auth.handle(url)
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

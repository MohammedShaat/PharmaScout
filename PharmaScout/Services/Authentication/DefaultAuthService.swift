//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct DefaultAuthService: AuthService {
    let auth = SupabaseManager.shared.client.auth
    
    func signUp(email: String, password: String) async throws -> AppUser {
        do {
            let authResponse = try await auth.signUp(email: email, password: password)
            
            guard let email = authResponse.user.email else {
                throw SignUpError.missingEmail
            }

            return AppUser(email: email)
            
        } catch let authError as AuthError {
            switch authError.errorCode {
            case .emailExists:
                throw SignUpError.emailAlreadyExists
                
            case .weakPassword:
                throw SignUpError.weakPassword
                
            case .overEmailSendRateLimit:
                throw SignUpError.emailRateLimit
                
            default:
                throw SignUpError.unknown(authError)
            }
        }
    }
}



//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct MockAuthService: AuthService {
    let auth = SupabaseManager.shared.client.auth
    
    func signUp(email: String, password: String) async throws -> AppUser {
        AppUser(email: "pharmascout@gmail.com")
    }
}

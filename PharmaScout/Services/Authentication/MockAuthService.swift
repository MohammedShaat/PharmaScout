//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct MockAuthService: AuthService {
    let authState: AsyncStream<AuthState> = AsyncStream { continuation in
        continuation.yield(.authenticated)
    }
    
    func signUp(email: String, password: String) async throws -> AppUser {
        AppUser(email: "pharmascout@email.com")
    }
    
    func handle(url: URL) {
        
    }
}




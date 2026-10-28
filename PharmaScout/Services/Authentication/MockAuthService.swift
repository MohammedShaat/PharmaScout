//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

struct MockAuthService: AuthService {
    let resendIntervalSec: Double = 10
    
    func signUp(email: String, password: String, fullName: String, redirectTo url: URL?) async throws {}
    
    func handle(url: URL, passwordReset: Bool) async throws {}
    
    func signIn(email: String, password: String) async throws {}
    
    func signOut() async throws {}
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {}
    
    func resetPassword(newPassword: String) async throws {}
    
    func signInWithCredential(_ credential: OAuthCredential) async throws {}
    
    func authStateStream() async -> AsyncStream<AuthState> {
        .makeStream().stream
    }
}




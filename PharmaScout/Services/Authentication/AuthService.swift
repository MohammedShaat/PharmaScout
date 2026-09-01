//
//  AuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

protocol AuthService {
    var authState: AsyncStream<AuthState> { get }

    func signUp(email: String, password: String) async throws -> AppUser
    
    func handle(url: URL)

    func signIn(email: String, password: String) async throws
    
    func signOut() async throws
}


//
//  AuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

protocol AuthService {
    func signUp(email: String, password: String) async throws -> AppUser
}

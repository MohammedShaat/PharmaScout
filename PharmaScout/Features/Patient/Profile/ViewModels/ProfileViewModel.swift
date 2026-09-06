//
//  ProfileViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class ProfileViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func logout() async {
        do {
            try await authService.signOut()
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
}

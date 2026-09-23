//
//  HomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class HomeViewModel {
    private let authService: AuthService
    
    private(set) var user: AppUser?
    private(set) var userName: String = ""
    var hasUnreadNotifications: Bool = true
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loadUserData() async {
        user = try? await authService.getUser()
    }
    
    
}

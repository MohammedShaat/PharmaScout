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
    private let pushTokenCoordinator: PushTokenCoordinator
    
    private(set) var logoutLoadingState = LoadingState()
    
    init(authService: AuthService, pushTokenCoordinator: PushTokenCoordinator) {
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
    }
    
    func logout() async {
        logoutLoadingState.startLoading()
        defer { logoutLoadingState.stopLoading() }
        
        do {
            await pushTokenCoordinator.willSignOut()
            try await authService.signOut()
            
        } catch {
            logoutLoadingState.fail(error)
            print("Failed to sign out: \(error)")
        }
    }
}

//
//  AdminProfileViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class OwnerApplicantProfileViewModel {
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

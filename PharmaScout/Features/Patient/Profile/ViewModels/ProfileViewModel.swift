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
    
    private(set) var loadingState = LoadingState()
    
    init(authService: AuthService, pushTokenCoordinator: PushTokenCoordinator) {
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
    }
    
    func logout() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            await pushTokenCoordinator.willSignOut()
            try await authService.signOut()
            
        } catch {
            loadingState.fail(error)
            print("Failed to sign out\n", error)
        }
    }
    
    func deleteAccount() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            await pushTokenCoordinator.willSignOut()
            try await authService.deleteUser()
            
        } catch {
            loadingState.fail(error)
            print("Failed to delete account\n", error)
        }
    }
}

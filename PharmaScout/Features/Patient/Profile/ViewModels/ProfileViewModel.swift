//
//  ProfileViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation
import UIKit

@Observable
class ProfileViewModel {
    private let authService: AuthService
    private let pushTokenCoordinator: PushTokenCoordinator
    private let reauthCoordinator: ReauthenticationCoordinator
    
    var passwordInput: String = ""
    var isPasswordValid: Bool { Validation.isPasswordValid(passwordInput) }
    
    var availableProviders: [AuthProvider]? { reauthCoordinator.availableProviders }
    var awaitingPassword: Bool { reauthCoordinator.awaitingPassword }

    var loadingState = LoadingState()
    
    init(
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        appleReauthenticationService: AppleReauthenticationService,
        googleReauthenticationService: GoogleReauthenticationService
    ) {
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.reauthCoordinator = ReauthenticationCoordinator(
            appleReauthenticationService: appleReauthenticationService,
            googleReauthenticationService: googleReauthenticationService
        )
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
    
    func deleteAccount(viewController vc: UIViewController) async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            let providers: [AuthProvider] = try await authService.getProviders()
            let reauth = try await reauthCoordinator.getCredential(viewController: vc, providers: providers)
            try await authService.deleteAccount(reauth: reauth)
            try await authService.clearLocalSession()
        } catch {
            loadingState.fail(error)
            print("Failed to delete account\n", error)
        }
    }
    
    func onProviderPicked(_ provider: AuthProvider?) {
        reauthCoordinator.pickProvider(provider)
    }
    
    func onPasswordConfirmed(submit: Bool) {
        reauthCoordinator.confirmPassword(submit: submit, passwordInput: passwordInput)
        passwordInput = ""
    }
}

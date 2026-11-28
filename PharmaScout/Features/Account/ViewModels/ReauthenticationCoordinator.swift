//
//  ReauthenticationCoordinator.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//

import Foundation
import UIKit

@Observable
class ReauthenticationCoordinator {
    private let appleReauthenticationService: AppleReauthenticationService
    private let googleReauthenticationService: GoogleReauthenticationService
    
    var availableProviders: [AuthProvider]?
    private var pickContinuation: CheckedContinuation<AuthProvider?, Never>?
    private var passwordContinuation: CheckedContinuation<String?, Never>?
    var awaitingPassword: Bool = false
    
    init(appleReauthenticationService: AppleReauthenticationService, googleReauthenticationService: GoogleReauthenticationService) {
        self.appleReauthenticationService = appleReauthenticationService
        self.googleReauthenticationService = googleReauthenticationService
    }
    
    func getCredential(viewController vc: UIViewController, providers: [AuthProvider]) async throws -> ReauthCredential {
        if providers.contains(.apple) {
            // Apple
            let appleAuthenticationCode = try await appleReauthenticationService.authorizationCode(viewController: vc)
            return ReauthCredential.apple(code: appleAuthenticationCode)
            
        } else {
            // Other options (Google, Email, ...)
            let pickedProvider = await withCheckedContinuation { continuation in
                availableProviders = providers
                pickContinuation = continuation
            }
            guard let pickedProvider else { throw ReauthError.canceled }
            
            switch pickedProvider {
            case .google:
                let idToken = try await googleReauthenticationService.idToken(viewController: vc)
                return ReauthCredential.google(idToken: idToken)
                
            case .email:
                let enteredPassword = await withCheckedContinuation { continuation in
                    passwordContinuation = continuation
                    awaitingPassword = true
                }
                guard let enteredPassword else { throw ReauthError.canceled }
                return ReauthCredential.email(password: enteredPassword)
                
            case .apple:
                throw ReauthError.unavailable
            }
        }
    }
    
    func pickProvider(_ provider: AuthProvider?) {
        availableProviders = nil
        pickContinuation?.resume(returning: provider)
        pickContinuation = nil
    }
    
    func confirmPassword(submit: Bool, passwordInput: String?) {
        awaitingPassword = false
        passwordContinuation?.resume(returning: submit ? passwordInput : nil)
        passwordContinuation = nil
    }
}

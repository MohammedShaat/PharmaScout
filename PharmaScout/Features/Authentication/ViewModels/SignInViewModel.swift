//
//  SignInViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import Foundation
import UIKit

@Observable
class SignInViewModel {
    private let authService: AuthService
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    
    var password: String = ""
    var email: String = ""
    var isPasswordHidden: Bool = true
    var areFieldsFilled: Bool {
        checkFieldsAreFilled()
    }
    
    private(set) var emailSignInLoadingState = LoadingState()
    private(set) var providerSignInLoadingState = LoadingState()
    
    init(authService: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        self.authService = authService
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    func signIn() async {
        emailSignInLoadingState.startLoading()
        defer { emailSignInLoadingState.stopLoading()}

        do {
            try checkInputsAreValid()
            
            try await authService.signIn(email: email, password: password)
            print("Signed in successfully", email)
            
        } catch {
            emailSignInLoadingState.fail(error)
            print("Failed to sign in\n", error)
        }
    }
    
    func signInWithGoogle(viewController vc: UIViewController) async {
        providerSignInLoadingState.startLoading()
        defer { providerSignInLoadingState.stopLoading() }

        do {
            let oAuthCredential = try await googleAuthService.signIn(viewController: vc)
            try await authService.signInWithCredential(oAuthCredential)
            print("Signing with Google succeeded")
            
        } catch {
            providerSignInLoadingState.fail(error)
            print("Failed to sign in with Google\n", error)
        }
    }
    
    
    func signInWithApple(viewController vc: UIViewController) async {
        providerSignInLoadingState.startLoading()
        defer { providerSignInLoadingState.stopLoading() }

        do {
            let oAuthCredential = try await appleAuthService.signIn(viewController: vc)
            try await authService.signInWithCredential(oAuthCredential)
            print("Signing with Apple succeeded")
            
        } catch {
            providerSignInLoadingState.fail(error)
            print("Failed to sign in with Apple\n", error)
        }
    }
}

extension SignInViewModel {
    private func checkFieldsAreFilled() -> Bool {
        email.isNotEmpty && password.isNotEmpty
    }
    
    private func checkInputsAreValid() throws {
        guard Validation.isEmailValid(email) else {
            throw AppAuthError.emailInvalid
        }
        guard Validation.isPasswordValid(password) else {
            throw AppAuthError.weakPassword
        }
    }
}

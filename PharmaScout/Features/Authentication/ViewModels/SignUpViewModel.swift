//
//  SignUpViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import UIKit

@Observable
class SignUpViewModel {
    private let authService: AuthService
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordHidden: Bool = true
    var areFieldsFilled: Bool {
        checkFieldsAreFilled()
    }
    
    private(set) var emailSignUpLoadingState = LoadingState()
    private(set) var providerSignInLoadingState = LoadingState()
    
    var confirmationSent: Bool = false
    
    private(set) var resendAvailableAfter: Date?
    var canResend: Bool {
        Date.now > (resendAvailableAfter ?? .distantPast)
    }
    
    init(authService: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        self.authService = authService
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    func signUp() async {
        emailSignUpLoadingState.startLoading()
        defer { emailSignUpLoadingState.stopLoading() }

        do {
            try checkInputsAreValid()
            updateResendAvailability()
            
            try await authService.signUp(
                email: email,
                password: password,
                redirectTo: DeepLink.emailConfirmation.url
            )
            confirmationSent = true
            print("Confirmation sent to ", email)
            
        } catch {
            emailSignUpLoadingState.fail(error)
            print("Failed to sign up\n", error)
        }
    }
    
    func resend() async {
        if canResend && emailSignUpLoadingState.status != .idle {
            await signUp()
        }
    }
    
    private func updateResendAvailability() {
        resendAvailableAfter = .now.addingTimeInterval(authService.resendIntervalSec)
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

extension SignUpViewModel {
    private func checkFieldsAreFilled() -> Bool {
        name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty
    }
    
    private func isNameValid() -> Bool {
        name.isNotEmpty
            && name.split(separator: " ").count >= 2
    }
    
    private func doPasswordsMatch() -> Bool {
        password == confirmPassword
    }
    
    private func checkInputsAreValid() throws {
        guard isNameValid() else {
            throw AppAuthError.nameInvalid
        }
        guard Validation.isEmailValid(email) else {
            throw AppAuthError.emailInvalid
        }
        guard Validation.isPasswordValid(password) else {
            throw AppAuthError.weakPassword
        }
        guard doPasswordsMatch() else {
            throw AppAuthError.passwordNotMatch
        }
    }
}

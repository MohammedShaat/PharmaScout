//
//  ResetPasswordViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import Foundation

@Observable
class ResetPasswordViewModel {
    private let authService: AuthService
    
    var email: String = ""
    var areEmailRequestFieldsFilled: Bool {
        checkEmailRequestFieldsAreFilled()
    }
    
    var requestLoadingState: LoadingState = LoadingState()
    var emailSent: Bool = false
    
    private(set) var resendAvailableAfter: Date?
    var canResend: Bool {
        Date.now > (resendAvailableAfter ?? .distantPast)
    }
    
    var newPassword: String = ""
    var confirmNewPassword: String = ""
    var isPasswordHidden: Bool = true
    var areNewPasswordFieldsFilled: Bool {
        checkNewPasswordFieldsAreFilled()
    }
    var passwordResetLoadingState: LoadingState = LoadingState()
    var passwordResetSuccessfully: Bool = false
    var showPasswordUpdated: Bool = false
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func sendResetLink() async {
        requestLoadingState.startLoading()
        defer { requestLoadingState.stopLoading() }
        
        do {
            try checkEmailRequestFieldsAreValid()
            updateResendAvailability()
            
            try await authService.sendPasswordResetRequest(email: email, redirectTo: DeepLink.passwordReset.url)
            emailSent = true
            print("Password reset request has been sent")
            
        } catch {
            requestLoadingState.fail(error)
            print("Failed to send request for password reset\n", error)
        }
    }
    
    func resend() async {
        if canResend && requestLoadingState.status == .idle {
            await sendResetLink()
        }
    }
    
    private func updateResendAvailability() {
        resendAvailableAfter = .now.addingTimeInterval(authService.resendIntervalSec)
    }
    
    func updatePassword() async {
        passwordResetLoadingState.startLoading()
        defer { passwordResetLoadingState.stopLoading() }
        
        do {
            try checkNewPasswordFieldsAreValid()
            
            try await authService.resetPassword(newPassword: newPassword)
            passwordResetSuccessfully = true
            showPasswordUpdated = true
            print("Password has been reset successfully")
            
        } catch {
            passwordResetLoadingState.fail(error)
            print("Failed to reset password\n", error)
        }
    }
}


extension ResetPasswordViewModel {
    private func checkEmailRequestFieldsAreFilled() -> Bool {
        email.isNotEmpty
    }

    private func checkEmailRequestFieldsAreValid() throws {
        guard Validation.isEmailValid(email) else {
            throw AppAuthError.emailInvalid
        }
    }
    
    private func checkNewPasswordFieldsAreFilled() -> Bool {
        newPassword.isNotEmpty && confirmNewPassword.isNotEmpty
    }
    
    private func checkNewPasswordFieldsAreValid() throws {
        guard Validation.isPasswordValid(newPassword) else {
            throw AppAuthError.weakPassword
        }
        
        guard newPassword == confirmNewPassword else {
            throw AppAuthError.passwordNotMatch
        }
    }
}

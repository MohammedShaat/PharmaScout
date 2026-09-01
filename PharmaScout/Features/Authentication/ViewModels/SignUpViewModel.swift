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
    private let googleAuthService: GoogleAuthService
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordHidden: Bool = true
    var areFieldsFilled: Bool {
        checkFieldsAreFilled()
    }
    
    private(set) var isLoading: Bool = false
    var signUpError: AppError?
    
    var confirmationSent: Bool = false
    
    private(set) var resendAvailableAfter: Date?
    var canResend: Bool {
        Date.now > (resendAvailableAfter ?? .distantPast)
    }
    
    private(set) var         isProviderSigningLoading: Bool = false
    
    init(authService: AuthService, googleAuthService: GoogleAuthService) {
        self.authService = authService
        self.googleAuthService = googleAuthService
    }
    
    func signUp() async {
        isLoading = true

        do {
            try checkInputsAreValid()
            updateResendAvailability()
            
            let user = try await authService.signUp(
                email: email,
                password: password,
                redirectTo: DeepLink.emailConfirmation.url
            )
            confirmationSent = true
            print("Confirmation sent to ", user.email)
            
        } catch let authError as AppAuthError {
            self.signUpError = authError
            print("Failed to sign up (AuthError): ", authError)
            
        } catch let networkError as NetworkError {
            signUpError = networkError
            print("Failed to sign up (NetworkError): ", networkError)
            
        } catch {
            signUpError = UnknownError.unKnown(error)
            print("Failed to sign up\n", error)
        }
        
        isLoading = false
    }
    
    func resend() async {
        if canResend && !isLoading {
            await signUp()
        }
    }
    
    private func updateResendAvailability() {
        resendAvailableAfter = .now.addingTimeInterval(authService.resendIntervalSec)
    }
    
    func signInWithGoogle(viewController vc: UIViewController) async {
        isProviderSigningLoading = true

        do {
            let oAuthCredential = try await googleAuthService.signIn(viewController: vc)
            try await authService.signInWithCredential(oAuthCredential)
            print("Signing with Google succeeded")
            
        } catch let authError as AppAuthError {
            self.signUpError = authError
            print("Failed to sign in with Google (AuthError): ", authError)
            
        } catch let error as GoogleSignInError {
            self.signUpError = error
            print("Failed to sign in with Google (GoogleSignInError): ", error)
            
        } catch let networkError as NetworkError {
            signUpError = networkError
            print("Failed to sign in with Google (NetworkError): ", networkError)
            
        } catch {
            signUpError = UnknownError.unKnown(error)
            print("Failed to sign in with Google\n", error)
        }
        
        isProviderSigningLoading = false
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

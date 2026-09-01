//
//  SignInViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import Foundation

@Observable
class SignInViewModel {
    private let authService: AuthService
    private let googleAuthService: GoogleAuthService
    
    var password: String = ""
    var email: String = ""
    var isPasswordHidden: Bool = true
    var areFieldsFilled: Bool {
        checkFieldsAreFilled()
    }
    
    private(set) var isLoading: Bool = false
    var signInError: AppError?
    
    init(authService: AuthService, googleAuthService: GoogleAuthService) {
        self.authService = authService
        self.googleAuthService = googleAuthService
    }
    
    func signIn() async {
        isLoading = true

        do {
            try checkInputsAreValid()
            
            try await authService.signIn(email: email, password: password)
            print("Signed in successfully", email)
            
        } catch let authError as AppAuthError {
            signInError = authError
            print("Failed to sign in (AuthError): ", authError)
            
        } catch let networkError as NetworkError {
            signInError = networkError
            print("Failed to sign in (NetworkError): ", networkError)
            
        } catch {
            signInError = UnknownError.unKnown(error)
            print("Failed to sign in\n", error)
        }
        
        isLoading = false
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

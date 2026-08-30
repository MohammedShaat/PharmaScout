//
//  SignUpViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

@Observable
class SignUpViewModel {
    private let authService: AuthService
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordHidden: Bool = true
    var areFieldsFilled: Bool {
        checkFieldsAreFilled()
    }
    
    private(set) var isLoading: Bool = false
    var signUpError: SignUpError?
    
    var confirmationSent: Bool = false

    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signUp() async {
        isLoading = true
        confirmationSent = false

        do {
            try checkInputsAreValid()
            
            let user = try await authService.signUp(email: email, password: password)
            confirmationSent = true
            print("Confirmation sent to ", user.email)
            
        } catch let authError as SignUpError {
            signUpError = authError
            print("Failed to sign up (AuthError)\n", authError)
        } catch {
            signUpError = .unknown(error)
            print("Failed to sign up\n", error)
        }
        
        isLoading = false
    }
    
    func resend() async {
        await signUp()
    }
    
    private func checkInputsAreValid() throws {
        guard isNameValid() else { throw SignUpError.nameInvalid }
        guard isEmailValid() else { throw SignUpError.emailInvalid }
        guard isPasswordValid() else { throw SignUpError.weakPassword }
        guard doPasswordsMatch() else { throw SignUpError.passwordNotMatch }
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
    
    private func isEmailValid() -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    private func isPasswordValid() -> Bool {
        password.count >= 8
    }
    
    private func doPasswordsMatch() -> Bool {
        password == confirmPassword
    }
}

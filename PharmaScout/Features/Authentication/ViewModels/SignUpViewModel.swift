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
            startCountdown()
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
    
    private func checkInputsAreValid() throws {
        guard isNameValid() else { throw SignUpError.nameInvalid }
        guard isEmailValid() else { throw SignUpError.emailInvalid }
        guard isPasswordValid() else { throw SignUpError.weakPassword }
        guard doPasswordsMatch() else { throw SignUpError.passwordNotMatch }
    }
    
    
    
    private var nextDate: Date?
    private let intervalSec: Double = 60
    private var timer: Timer?
    private(set) var remainingSec: Double = 0
    
    func resend() async {
        if remainingSec <= 0 && !isLoading {
            startCountdown()
            await signUp()
        }
    }
    
    func startCountdown() {
        timer?.invalidate()
        nextDate = .now.addingTimeInterval(intervalSec)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.remainingSec = max(0, nextDate?.timeIntervalSinceNow ?? 0)
            
            if self.remainingSec <= 0 {
                stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        remainingSec = 0
    }
    
    deinit {
        stopCountdown()
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

//
//  ForgotPasswordScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    let authService: AuthService
    @State private var vm: ResetPasswordViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(authSerivce: AuthService) {
        self.authService = authSerivce
        self._vm = State(wrappedValue: ResetPasswordViewModel(authService: authSerivce))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            descriptionSection
            
            formSection
            
            Spacer()
            
            doNotHaveAnAccountSection
        }
        .padding(.horizontal, Spacing.xxLarge)
        .errorAlert(title: "Request Failed", error: $vm.requestError)
        .navigationDestination(isPresented: $vm.emailSent) {
            destination
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            CircularIconView(image: .lock)
            
            Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            Text("Enter the email address associated with your PharmaScout account and we'll send you a link to reset your password.")
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            PrimaryButtonView(title: "Send Reset Link", isDisabled: !vm.areEmailRequestFieldsFilled, isLoading: vm.isLoading) {
                Task {
                    await vm.sendResetLink()
                }
            }
            .padding(.vertical, Spacing.medium)
        }
        .padding(.vertical, Spacing.xxLarge)
    }
    
    private var doNotHaveAnAccountSection: some View {
        ActionPromptView(text: "Remembered it?", actionTitle: "Back to Sign Up") {
            dismiss()
        }
        .padding(.top, Spacing.xLarge)
    }
    
    private var destination: some View {
        CheckEmailView(
            emailPurposeText: "We sent a password reset link to",
            instructionText: "Open the link to reset your password and create a new one.",
            email: vm.email,
            resendAvailableAfter: vm.resendAvailableAfter ?? .now,
            canResend: { vm.canResend }) {
                Task {
                    await vm.resend()
                }
            }
            .errorAlert(title: "Resend Failed", error: $vm.requestError)
    }
}

#Preview {
    CustomNavStack {
        ForgotPasswordScreen(authSerivce: MockAuthService.sample)
    }
}

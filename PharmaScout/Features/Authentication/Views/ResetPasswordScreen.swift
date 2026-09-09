//
//  ResetPasswordScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import SwiftUI

struct ResetPasswordScreen: View {
    let router: AppRouter
    @State private var vm: ResetPasswordViewModel
    
    init(authSerivce: AuthService, router: AppRouter) {
        self.router = router
        self._vm = State(wrappedValue: ResetPasswordViewModel(authService: authSerivce))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            descriptionSection
            
            formSection
            
            Spacer()
            
            doNotHaveAnAccountSection
        }
        .padding(.horizontal, DesignSystem.Spacing.xxLarge)
        .errorAlert(title: "Password Reset Failed", error: $vm.passwordResetError)
        .sheet(isPresented: $vm.showPasswordUpdated, onDismiss: router.onPasswordResetSucceeed) {
            PasswordUpdatedView(onContinueClicked: router.onPasswordResetSucceeed)
                .presentationDetents([.medium])
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            Text("Type New Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            VStack(alignment: .leading) {
                Text("Choose a new password for \(vm.email).")
                Text("You'll use it the next time you sign in.")
            }
            .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            LabeledSecureFieldView(title: $vm.newPassword, label: "New password", isInputHidden: $vm.isPasswordHidden)
            
            LabeledSecureFieldView(title: $vm.confirmNewPassword, label: "Confirm new password", isInputHidden: $vm.isPasswordHidden)
            
            PrimaryButtonView(title: "Reset Password", isDisabled: !vm.areNewPasswordFieldsFilled, isLoading: vm.isLoading) {
                Task {
                    await vm.updatePassword()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
        .padding(.vertical, DesignSystem.Spacing.medium)
    }
    
    private var doNotHaveAnAccountSection: some View {
        ActionPromptView(actionTitle: "Back to Sign In") {
            router.navigateToSignIn()
        }
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
}

#Preview {
    CustomNavStack {
        ResetPasswordScreen(authSerivce: MockAuthService.sample, router: .sample)
    }
}

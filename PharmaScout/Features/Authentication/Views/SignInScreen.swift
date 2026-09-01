//
//  SignInScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignInScreen: View {
    let authService: AuthService
    let googleAuthService: GoogleAuthService
    @State private var vm: SignInViewModel
    
    init(authService: AuthService, googleAuthService: GoogleAuthService) {
        self.authService = authService
        let viewModel = SignInViewModel(authService: authService, googleAuthService: googleAuthService)
        self._vm = State(wrappedValue: viewModel)
        self.googleAuthService = googleAuthService
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
//                inlineHeaderSection
                
                descriptionSection
                
                formSection
                
                providersSection
                
                doNotHaveAnAccountSection
            }
            .padding(.horizontal, Spacing.xxLarge)
            .errorAlert(title: "Sign In Failed", error: $vm.signInError)
        }
    }
    
    private var inlineHeaderSection: some View {
        PharmaScoutLabelView(isLarge: false)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.small)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Welcome back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            Text("Sign in to continue finding the medicines you need.")
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $vm.password, label: "Password", isInputHidden: $vm.isPasswordHidden)
            
            CustomNavLink {
                ForgotPasswordScreen(authSerivce: authService)
            } label: {
                Text("Forgot password?")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }
            
            PrimaryButtonView(title: "Sign In", isDisabled: !vm.areFieldsFilled, isLoading: vm.isLoading) {
                Task {
                    await vm.signIn()
                }
            }
            .padding(.vertical, Spacing.medium)
        }
        .padding(.vertical, Spacing.xxLarge)
    }
    
    private var providersSection: some View {
        HStack(spacing: Spacing.large) {
            Rectangle()
                .fill(.theme.disabledBackground)
                .frame(height: 0.5)
            
            Text("OR")
                .foregroundStyle(.theme.textSecondary)
            
            Rectangle()
                .fill(.theme.disabledBackground)
                .frame(height: 0.5)
        }
    }
    
    private var doNotHaveAnAccountSection: some View {
        NavigationPromptView(text: "Don't have an account?", actionTitle: "Sign Up") {
            SignUpScreen(authService: authService, googleAuthService: googleAuthService)
        }
        .padding(.top, Spacing.xLarge)
    }
}

#Preview {
    CustomNavStack {
        SignInScreen(authService: MockAuthService.sample, googleAuthService: MockGoogleAuthService.sample)
            .customNavBarVisibility(true)
    }
}

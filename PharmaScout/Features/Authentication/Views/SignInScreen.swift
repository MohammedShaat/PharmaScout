//
//  SignInScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignInScreen: View {
    @State private var vm: SignInViewModel
    
    init(authService: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        let viewModel = SignInViewModel(authService: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService)
        self._vm = State(wrappedValue: viewModel)
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
            .padding(.horizontal, DesignSystem.Spacing.xxLarge)
            .errorAlert(title: "Sign In Failed", error: $vm.signInError)
        }
    }
    
    private var inlineHeaderSection: some View {
        PharmaScoutLabelView(isLarge: false)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, DesignSystem.Spacing.small)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            Text("Welcome back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            Text("Sign in to continue finding the medicines you need.")
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $vm.password, label: "Password", isInputHidden: $vm.isPasswordHidden)
            
            CustomNavValueLink(value: AuthenticationRoute.forgotPassword) {
                Text("Forgot password?")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }
            
            PrimaryButtonView(title: "Sign In", isDisabled: !vm.areFieldsFilled, isLoading: vm.isSignWithEmailLoading) {
                Task {
                    await vm.signIn()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
    
    private var providersSection: some View {
        SignInWithProvidersView(isDisabled: vm.isProviderSigningLoading) {
            Task {
                if let vc = UIApplication.shared.viewController {
                    await vm.signInWithApple(viewController: vc)
                }
            }
        } onGoogleButtonTapped: {
            Task {
                if let vc = UIApplication.shared.viewController {
                    await vm.signInWithGoogle	(viewController: vc)
                }
            }
        }
    }
    
    private var doNotHaveAnAccountSection: some View {
        NavigationPromptView(
            value: AuthenticationRoute.signUp,
            text: "Don't have an account?",
            actionTitle: "Sign Up"
        )
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
}

#Preview {
    CustomNavStack {
        SignInScreen(
            authService: MockAuthService.sample,
            googleAuthService: MockGoogleAuthService.sample,
            appleAuthService: MockAppleAuthService.sample
        )
            .customNavBarVisibility(true)
    }
}

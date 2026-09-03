//
//  SignUpScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignUpScreen: View {
    private let authService: AuthService
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    @State private var vm: SignUpViewModel
    
    init(authService: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        self.authService = authService
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        
        let viewModel = SignUpViewModel(
            authService: authService,
            googleAuthService: googleAuthService,
            appleAuthService: appleAuthService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
//                inlineHeaderSection
                
                descriptionSection
                
                formSection
                
                providersSection
                
                alreadyHaveAnAccountSection
            }
            .padding(.horizontal, Spacing.xxLarge)
            .errorAlert(title: "Sign Up Failed", error: $vm.signUpError)
            .navigationDestination(isPresented: $vm.confirmationSent) {
                destination
            }
        }
    }
    
    private var inlineHeaderSection: some View {
        PharmaScoutLabelView(isLarge: false)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.small)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Create your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            Text("Create an account to search for medicines and find nearby pharmacies.")
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            LabeledTextFieldView(title: $vm.name, label: "Full name", placeholder: "Enter your name", capitalization: .words)
            
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $vm.password, label: "Password", isInputHidden: $vm.isPasswordHidden)
            
            LabeledSecureFieldView(title: $vm.confirmPassword, label: "Confirm password", isInputHidden: $vm.isPasswordHidden)
            
            PrimaryButtonView(title: "Create Account", isDisabled: !vm.areFieldsFilled || vm.isProviderSigningLoading, isLoading: vm.isSignInWithEmailLoading) {
                Task {
                    await vm.signUp()
                }
            }
            .padding(.vertical, Spacing.medium)
        }
        .padding(.vertical, Spacing.xxLarge)
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
                    await vm.signInWithGoogle(viewController: vc)
                }
            }
        }
    }
    
    private var alreadyHaveAnAccountSection: some View {
        NavigationPromptView(text: "Already have an account?", actionTitle: "Sign In") {
            SignInScreen(
                authService: authService,
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService
            )
        }
        .padding(.top, Spacing.xLarge)
    }
    
    private var destination: some View {
        CheckEmailView(
            emailPurposeText: "We sent a confirmation link to",
            instructionText: "Open the link to verify your address.",
            email: vm.email,
            resendAvailableAfter: vm.resendAvailableAfter ?? .now,
            canResend: { vm.canResend }) {
                Task {
                    await vm.resend()
                }
            }
            .errorAlert(title: "Resend Failed", error: $vm.signUpError)
    }
}

#Preview {
    CustomNavStack {
        SignUpScreen(
            authService: MockAuthService.sample,
            googleAuthService: MockGoogleAuthService.sample,
            appleAuthService: MockAppleAuthService.sample
        )
        .customNavBarVisibility(true)
    }
}

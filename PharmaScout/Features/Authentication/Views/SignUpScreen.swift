//
//  SignUpScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignUpScreen: View {
    private let onSignInTapped: () -> Void
    
    @State private var vm: SignUpViewModel
    @State private var signUpTask: Task<Void, Never>?
    
    init(
        authService: AuthService,
        googleAuthService: OAuthService,
        appleAuthService: OAuthService,
        onSignInTapped: @escaping () -> Void
    ) {
        self.onSignInTapped = onSignInTapped
        
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
            .padding(.horizontal, DesignSystem.Spacing.xxLarge)
            .errorAlert(
                title: "Sign Up Failed",
                loadingState: vm.emailSignUpLoadingState.error != nil
                ? $vm.emailSignUpLoadingState
                : $vm.providerSignInLoadingState
            )
            .navigationDestination(isPresented: $vm.confirmationSent) {
                destination
            }
            .onDisappear {
                signUpTask?.cancel()
            }
        }
    }
    
    private var inlineHeaderSection: some View {
        PharmaScoutLabelView(isLarge: false)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, DesignSystem.Spacing.small)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            Text("Create your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
            
            Text("Create an account to search for medicines and find nearby pharmacies.")
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            LabeledTextFieldView(title: $vm.name, label: "Full name", placeholder: "Enter your name", capitalization: .words)
            
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $vm.password, label: "Password", isInputHidden: $vm.isPasswordHidden)
            
            LabeledSecureFieldView(title: $vm.confirmPassword, label: "Confirm password", isInputHidden: $vm.isPasswordHidden)
            
            PrimaryButtonView(
                title: "Create Account",
                isDisabled: !vm.areFieldsFilled || vm.providerSignInLoadingState.status != .idle,
                isLoading: vm.emailSignUpLoadingState.status != .idle
            ) {
                signUpTask?.cancel()
                signUpTask = Task {
                    await vm.signUp()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
    
    private var providersSection: some View {
        SignInWithProvidersView(isDisabled: vm.emailSignUpLoadingState.status != .idle || vm.providerSignInLoadingState.status != .idle) {
            signUpTask?.cancel()
            signUpTask = Task {
                if let vc = UIApplication.shared.viewController {
                    await vm.signInWithApple(viewController: vc)
                }
            }
        } onGoogleButtonTapped: {
            signUpTask?.cancel()
            signUpTask = Task {
                if let vc = UIApplication.shared.viewController {
                    await vm.signInWithGoogle(viewController: vc)
                }
            }
        }
    }
    
    private var alreadyHaveAnAccountSection: some View {
        ActionPromptView(text: "Already have an account?", actionTitle: "Sign In") {
            onSignInTapped()
        }
        .padding(.top, DesignSystem.Spacing.xLarge)
    }
    
    private var destination: some View {
        CheckEmailView(
            emailPurposeText: "We sent a confirmation link to",
            instructionText: "Open the link to verify your address.",
            email: vm.email,
            resendAvailableAfter: vm.resendAvailableAfter ?? .now,
            canResend: { vm.canResend }) {
                signUpTask?.cancel()
                signUpTask = Task {
                    await vm.resend()
                }
            }
            .errorAlert(title: "Resend Failed", loadingState: $vm.emailSignUpLoadingState)
    }
}

#Preview {
    CustomNavStack {
        SignUpScreen(
            authService: MockAuthService.sample,
            googleAuthService: MockGoogleAuthService.sample,
            appleAuthService: MockAppleAuthService.sample,
            onSignInTapped: {}
        )
        .customNavBarVisibility(true)
    }
}
	

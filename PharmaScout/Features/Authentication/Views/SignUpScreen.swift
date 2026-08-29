//
//  SignUpScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignUpScreen: View {
    private let authService: AuthService
    @State private var vm: SignUpViewModel
    
    init(authService: AuthService) {
        self.authService = authService
        self._vm = State(wrappedValue: SignUpViewModel(authService: authService))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                inlineHeaderSection
                
                descriptionSection
                
                formSection
                
                providersSection
                
                alreadyHaveAnAccountSection
            }
            .padding(.horizontal, Spacing.xxLarge)
            .alert(
                "Sign Up Failed",
                isPresented: .init(get: {
                    vm.signUpError != nil
                }, set: { newValue in
                    if !newValue {
                        vm.signUpError = nil
                    }
                }),
                presenting: vm.signUpError
            ) { _ in
                
            } message: { error in
                switch error {
                case .emailAlreadyExists:
                    Text("This email is already registered. Try signing in instead.")
                case .weakPassword:
                    Text("Your password is too weak. Please choose a stronger password.")
                case .emailRateLimit:
                    Text("Too many attempts. Please wait a while before trying again.")
                default:
                    Text("Something went wrong. Please try again later.")
                }
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
            LabeledTextFieldView(title: $vm.name, label: "Full name", placeholder: "Enter your name")
            
            LabeledTextFieldView(title: $vm.email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $vm.password, label: "Password", isInputHidden: $vm.isPasswordHidden)
            
            LabeledSecureFieldView(title: $vm.confirmPassword, label: "Confirm password", isInputHidden: $vm.isPasswordHidden)
            
            PrimaryButtonView(title: "Create Account", isDisabled: !vm.areFieldsFilled) {
                Task {
                    await vm.signUp()//mohammedshaat.it@gmai.com
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
    
    private var alreadyHaveAnAccountSection: some View {
        HStack {
            Text("Already have an account?")
                .foregroundStyle(.theme.textSecondary)
            
            CustomNavLink {
                SignInScreen(authSerivce: authService)
            } label: {
                Text("Sign In")
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }

        }
        .padding(.top, Spacing.xLarge)
    }
}

#Preview {
    CustomNavStack {
        SignUpScreen(authService: MockAuthService.sample)
            .customNavBarVisibility(true)
    }
}

//
//  SignInScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignInScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isSignInDisabled: Bool = true
    
    let authService: AuthService
    
    init(authSerivce: AuthService) {
        self.authService = authSerivce
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                inlineHeaderSection
                
                descriptionSection
                
                formSection
                
                providersSection
                
                doNotHaveAnAccountSection
            }
            .padding(.horizontal, Spacing.xxLarge)
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
            LabeledTextFieldView(title: $email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $password, label: "Password", isInputHidden: $isPasswordHidden)
            
            Text("Forgot password?")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(.theme.primary)
                .font(.headline)
            
            PrimaryButtonView(title: "Sign In", isDisabled: isSignInDisabled)
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
        HStack {
            Text("Don't have an account?")
                .foregroundStyle(.theme.textSecondary)
            
            CustomNavLink {
                SignUpScreen(authService: authService)
            } label: {
                Text("Sign Up")
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }
            
        }
        .padding(.top, Spacing.xLarge)
    }
}

#Preview {
    CustomNavStack {
        SignInScreen(authSerivce: MockAuthService.sample)
            .customNavBarVisibility(true)
    }
}

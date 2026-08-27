//
//  SignUpScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isCreateAccountDisabled: Bool = true
    
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
            LabeledTextFieldView(title: $name, label: "Full name", placeholder: "Enter your name")
            
            LabeledTextFieldView(title: $email, label: "Email", placeholder: "name@email.com")
            
            LabeledSecureFieldView(title: $password, label: "Password", isInputHidden: $isPasswordHidden)
            
            LabeledSecureFieldView(title: $confirmPassword, label: "Confirm password", isInputHidden: $isPasswordHidden)
            
            PrimaryButtonView(title: "Create Account", isDisabled: isCreateAccountDisabled) {
                
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
                SignInScreen()
            } label: {
                Text("Sign In")
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }

        }
        .padding(.top, Spacing.large)
    }
}

#Preview {
    CustomNavStack {
        SignUpScreen()
            .customNavBarVisibility(true)
    }
}

//
//  SignInWithProvidersView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/5/26.
//

import SwiftUI

struct SignInWithProvidersView: View {
    let isDisabled: Bool
    let onAppleButtonTapped: (() -> Void)
    let onGoogleButtonTapped: (() -> Void)
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            orDivider
            
            AppleSginInButtonView {
                onAppleButtonTapped()
            }
            .disabled(isDisabled)
            
            
            GoogleSignInButtonView {
                onGoogleButtonTapped()
            }
            .disabled(isDisabled)
        }
    }
    
    private var orDivider: some View {
        HStack(spacing: Spacing.large) {
            Rectangle()
                .fill(.theme.borderFocused)
                .frame(height: 0.5)
            
            Text("OR")
                .foregroundStyle(.theme.textSecondary)
            
            Rectangle()
                .fill(.theme.borderFocused)
                .frame(height: 0.5)
        }
    }
}

#Preview {
    SignInWithProvidersView(isDisabled: false) {
        
    } onGoogleButtonTapped: {
        
    }
    .padding()
}

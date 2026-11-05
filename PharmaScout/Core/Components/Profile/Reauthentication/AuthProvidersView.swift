//
//  ProvidersView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct AuthProvidersView: View {
    let providers: [AuthProvider]
    let onContinueInWithGoogleTapped: (AuthProvider) -> Void
    let onPasswordTapped: (AuthProvider) -> Void
    let onCancelTapped: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Confirm it’s you")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Text("Sign in again with the method you use for this account to continue deleting it.")
                    .foregroundStyle(.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: DesignSystem.Spacing.large) {
                ForEach(providers) { provider in
                    switch provider {
                    case .google:
                        GoogleSignInButtonView {
                            onContinueInWithGoogleTapped(provider)
                        } 
                        
                    case .email:
                        PrimaryButtonView(title: "Password") {
                            onPasswordTapped(provider)
                        }
                        
                    case .apple:
                        EmptyView()
                    }
                }
            }
            .padding(.top, DesignSystem.Spacing.xLarge)
            
            ActionPromptView(actionTitle: "Cancel", action: onCancelTapped)
            .padding(.vertical, DesignSystem.Spacing.large)
            
            Spacer()
        }
    }
}

#Preview {
    AuthProvidersView(
        providers: [.google, .email],
        onContinueInWithGoogleTapped: { _ in },
        onPasswordTapped: { _ in },
        onCancelTapped: {}
    )
}

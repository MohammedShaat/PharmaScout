//
//  AuthPasswordView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct AuthPasswordView: View {
    @Binding var password: String
    let isDisabled: Bool
    let isLoading: Bool
    let onDeleteTapped: () -> Void
    let onCancelTapped: () -> Void
    
    @State private var isPasswordHidden: Bool = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Enter your password")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Text("Your account and data will be permanently deleted. This can’t be undone.")
                    .foregroundStyle(.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LabeledSecureFieldView(title: $password, label: "Account password", isInputHidden: $isPasswordHidden)
                .padding(.vertical, DesignSystem.Spacing.large)
            
            Spacer()
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                PrimaryButtonView(
                    title: "Delete Account",
                    isDisabled: isDisabled,
                    isLoading: isLoading,
                    bgColor: .theme.red
                ) {
                    onDeleteTapped()
                }
                    
                ActionPromptView(actionTitle: "Cancel") {
                    onCancelTapped()
                }
            }
        }
    }
}

#Preview {
    AuthPasswordView(
        password: .constant(""),
        isDisabled: false,
        isLoading: false,
        onDeleteTapped: {},
        onCancelTapped: {}
    )
}

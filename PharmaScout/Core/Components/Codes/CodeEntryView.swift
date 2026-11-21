//
//  CodeEntryView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/16/26.
//

import SwiftUI

struct CodeEntryView: View {
    let title: String
    let subtitle: String
    @Binding var code: String
    let codeLength: Int
    let loadingState: LoadingState
    let canSend: Bool
    let onSendTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            instructionAndInputSection
            
            Spacer()
            errorSection
            
            sendButton
        }
    }
    
    private var instructionAndInputSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            BigIconView(systemName: "key.horizontal")
            
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.theme.textSecondary)
                
                Text("The code must be \(codeLength) characters long.")
                    .foregroundStyle(.theme.textSecondary)
            }
            .multilineTextAlignment(.center)
            
            TextFieldView(title: $code, placeholder: "Enter the code here")
                .frame(maxWidth: 200)
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = loadingState.error {
            ErrorView(title: "Code failed.", description: error.errorDescription)
        }
    }
    
    private var sendButton: some View  {
        PrimaryButtonView(
            title: "Send",
            isDisabled: !canSend,
            isLoading: loadingState.status != .idle,
            action: onSendTapped
        )
        .padding(.vertical, DesignSystem.Spacing.large)
    }
}

#Preview {
    @State @Previewable var code = ""
    
    CodeEntryView(
        title: "Enter the code to apply for pharmacy ownership",
        subtitle: "Ownership codes are issued personally. Ask the PharmaScout team for yours.",
        code: $code,
        codeLength: 8,
        loadingState: LoadingState(),
        canSend: true,
        onSendTapped: {}
    )
}

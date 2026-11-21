//
//  CodeEntryView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/16/26.
//

import SwiftUI

struct CodeGenerationView: View {
    let title: String
    let subtitle: String
    let systemName: String
    let invitationCode: InvitationCode?
    let codeLength: Int
    let loadingState: LoadingState
    let shareLinkSubject: String
    let shareLinkMessage: String
    let leakMessage: String
    let onGenerateTapped: () -> Void
    let onRegenerateTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            instructionSection
            
            Spacer()
            codeSection
        }
    }
    
    private var instructionSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            BigIconView(systemName: systemName)
            
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.theme.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
    }
    
    private var codeSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            if loadingState.status != .idle {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    RingProgressView()
                    Text("Getting your code…")
                        .font(.headline)
                        .foregroundStyle(.theme.secondaryStrong)
                }
                .padding(.vertical, DesignSystem.Spacing.xLarge)
                Spacer()
                
            } else if let invitationCode {
                VStack(spacing: DesignSystem.Spacing.large) {
                    Text(invitationCode.code)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: DesignSystem.Spacing.xSmall) {
                        Label("Expireson on", systemImage: "clock")
                            .foregroundStyle(.theme.textSecondary)
                        
                        Text(invitationCode.expiresAt.formattedDateTime)
                            .fontWeight(.bold)
                    }
                    .padding(DesignSystem.Spacing.medium)
                    .roundedBackground()
                }
                .foregroundStyle(.theme.textPrimary)
                
                Spacer()
                errorSection
                
                actionsSection(invitationCode)
                
            } else {
                errorSection
                
                PrimaryButtonView(title: "Generate", action: onGenerateTapped)
            }
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = loadingState.error {
            ErrorView(title: "Code generation failed.", description: error.errorDescription)
        }
    }
    
    private func actionsSection(_ invitationCode: InvitationCode) -> some View  {
        VStack(spacing: DesignSystem.Spacing.large) {
            HStack(spacing: DesignSystem.Spacing.large) {
                // Share button
                ShareLink(
                    item: invitationCode.code,
                    subject: Text(shareLinkSubject),
                    message: Text(shareLinkMessage)
                ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .foregroundStyle(.theme.onPrimary)
                    .padding(.horizontal, DesignSystem.Spacing.xLarge)
                    .padding(.vertical, DesignSystem.Spacing.large)
                    .roundedBackground(
                        background: loadingState.status != .idle ? .theme.primary.opacity(0.5) : .theme.primary,
                        radius: DesignSystem.CornerRadius.small
                    )
                }
                .disabled(loadingState.status != .idle)
                
                // Copy button
                ButtonWithIconView(title: "Copy", systemName: "doc.on.doc", color: .theme.textPrimary, bgColor: .theme.surface, isDisabled: loadingState.status != .idle) {
                    copyToClipboard(invitationCode.code)
                }
            }
            
            Text("Think the code was leaked?\n\(leakMessage)")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.theme.textSecondary)
            
            // Regenerate button
            Label("Regenerate", systemImage: "arrow.trianglehead.clockwise")
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
                .clickable(isDisabled: loadingState.status != .idle, action: onRegenerateTapped)
        }
    }
}

#Preview {
    @State @Previewable var loadingState = {
        var state = LoadingState()
//        state.startLoading()
        return state
    }()
    
    @State @Previewable var invitationCode: InvitationCode? = nil
    
    
    CustomNavStack {
        CodeGenerationView(
            title: "Your join code",
            subtitle: "share this 8-character code with staff members who want to join your pharmacy.",
            systemName: "person.badge.plus",
            invitationCode: invitationCode,
            codeLength: 8,
            loadingState: loadingState,
            shareLinkSubject: "Pharmacy Join Code",
            shareLinkMessage: "Use this code to join our pharmacy.",
            leakMessage: "Regenerate it and the old one stops working.",
            onGenerateTapped: {},
            onRegenerateTapped: {}
        )
        .padding()
    }
}

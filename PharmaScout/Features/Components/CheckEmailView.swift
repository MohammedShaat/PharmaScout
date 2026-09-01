//
//  EmailConfirmationScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct CheckEmailView: View {
    let emailPurposeText: String
    let instructionText: String
    let email: String
    let resendAvailableAfter: Date
    let canResend: () -> Bool
    let onResendClicked: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            infoSection
            
            Spacer()
            
            actionsSection
        }
        .padding(.horizontal, Spacing.xxLarge)
    }
    
    private var infoSection: some View {
        VStack(spacing: Spacing.large) {
            CircularIconView(image: .mail, bgSize: 130, iconSize: 70, bgColor: .theme.success.opacity(0.2))
            
            Text("Check Your Email")
                .font(.title)
                .foregroundStyle(.theme.textPrimary)
                .fontWeight(.bold)
            
            Text(emailPurposeText)
                .foregroundStyle(.theme.textSecondary)
            
            Text(email)
                .foregroundStyle(.theme.textPrimary)
                .fontWeight(.bold)
            
            VStack {
                Text(instructionText)
                Text("Check your spam folder if it hasn't arrived.")
            }
                .multilineTextAlignment(.center)
                .foregroundStyle(.theme.textSecondary)
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 0) {
            if let url = URL(string: "mailto:"),
               UIApplication.shared.canOpenURL(url) {
                PrimaryButtonView(title: "Open Mail") {
                    UIApplication.shared.open(url)
                }
            }
            
            TimelineView(.periodic(from: .now, by: 1)) { context in
                HStack(spacing: 0) {
                    Text("Resend email")
                        .foregroundStyle(.theme.textPrimary)
                        .clickable(isDisabled: !canResend()) {
                            onResendClicked()
                        }
                    
                    let remainingSec = resendAvailableAfter.timeIntervalSince(context.date)
                    
                    if remainingSec > 0 {
                        HStack(spacing: 0) {
                            Text(" in ")
                            Text(Duration.seconds(remainingSec).formatted(.time(pattern: .minuteSecond)))
                        }
                        .foregroundStyle(.theme.textPrimary)
                    }
                }
                .font(.headline)
                .padding(.vertical, Spacing.large)
            }
            
            ActionPromptView(text: "Wrong address?", actionTitle: "Edit email") {
                dismiss()
            }
            .padding(.top, Spacing.xLarge)
        }
    }
}

#Preview {
    let interval = MockAuthService().resendIntervalSec
    let resendAt: Date = .now.addingTimeInterval(interval)
    var canResend: Bool {
        .now > resendAt
    }
    
    CustomNavStack {
        CheckEmailView(
            emailPurposeText: "We sent a confirmation link to",
            instructionText: "Open the link to ....",
            email: "pharmascout@email.com",
            resendAvailableAfter: resendAt,
            canResend: { canResend }) {
                
            }
    }
}

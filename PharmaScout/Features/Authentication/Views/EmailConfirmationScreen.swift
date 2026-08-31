//
//  EmailConfirmationScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct EmailConfirmationScreen: View {
    @Bindable var vm: SignUpViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var refreshTrigger: Bool = .random()
    
    init(viewModel: SignUpViewModel) {
        self.vm = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            infoSection
            
            Spacer()
            
            actionsSection
        }
        .padding(.horizontal, Spacing.xxLarge)
        .errorAlert(title: "Failed to resend", error: $vm.signUpError)
    }
    
    private var infoSection: some View {
        VStack(spacing: Spacing.large) {
            Circle()
                .fill(.theme.success.opacity(0.3))
                .frame(width: 150)
                .overlay {
                    Image(.mail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                }
            
            Text("Email confirmation sent")
                .font(.title)
                .foregroundStyle(.theme.textPrimary)
                .fontWeight(.bold)
            
            Text("We sent a confirmation link to")
                .foregroundStyle(.theme.textSecondary)
            
            Text(vm.email)
                .foregroundStyle(.theme.textPrimary)
                .fontWeight(.bold)
            
            Text("Open the link to verify your address and finish setting up your account.")
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
                    Text("Resend confirmation email")
                        .foregroundStyle(.theme.textPrimary)
                        .clickable(isDisabled: !vm.canResend) {
                            Task {
                                await vm.resend()
                            }
                        }
                    
                    let seconds = vm.resendAvailableAfter?.timeIntervalSince(context.date) ?? 0
                    
                    if !vm.canResend {
                        HStack(spacing: 0) {
                            Text(" in ")
                            Text(Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond)))
                        }
                        .foregroundStyle(.theme.textPrimary)
                    }
                }
                .font(.headline)
                .padding(.vertical, Spacing.large)
            }
            
            
            HStack(spacing: Spacing.xLarge) {
                Text("Wrong address?")
                    .foregroundStyle(.theme.textSecondary)
                
                Text("Edit email")
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
                    .clickable {
                        dismiss()
                    }
            }
            .padding(.top, Spacing.xLarge)
        }
    }
}

#Preview {
    CustomNavStack {
        EmailConfirmationScreen(viewModel: .sample)
    }
}

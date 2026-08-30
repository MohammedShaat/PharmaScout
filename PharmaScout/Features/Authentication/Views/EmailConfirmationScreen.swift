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
            PrimaryButtonView(title: "Open Mail")
            
                Text("Resend confirmation email")
                    .foregroundStyle(.theme.textPrimary)
                    .font(.headline)
                    .padding(.vertical, Spacing.large)
                    .clickable {
                        Task {
                            await vm.resend()
                        }
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

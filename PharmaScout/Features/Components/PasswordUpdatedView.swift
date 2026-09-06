//
//  PasswordUpdatedView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import SwiftUI

struct PasswordUpdatedView: View {
    var onContinueClicked: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            Spacer()
            
            CircularIconView(image: .checkmarkImg, bgColor: .theme.success.opacity(0.3))
            
            Text("Password Updated")
                .foregroundStyle(.theme.textPrimary)
                .font(.title2)
                .fontWeight(.bold)
            
            
            VStack {
                Text("Your password has been changed.")
                Text("You’re all set—continue to start scouting nearby pharmacies.")
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .foregroundStyle(.theme.textSecondary)

            Spacer()
            Spacer()
            
            PrimaryButtonView(title: "Continue") {
                onContinueClicked?()
            }
            Spacer()
        }
        .padding(.horizontal, Spacing.large)
    }
}

#Preview {
    CustomNavStack {
        VStack {
            Text("New Password")
        }
        .sheet(isPresented: .constant(true)) {
            PasswordUpdatedView()
                .presentationDetents([.medium])

        }
    }
}

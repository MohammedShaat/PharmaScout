//
//  WelcomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct WelcomeScreen: View {
    let onGetStartedTapped: () -> Void
    let onHaveAccountTapped: () -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack {
            headerSection
            
            Spacer()
            
            logoSection
            
            Spacer()
            
            descriptionSection
            
            Spacer()
            
            buttonsSection
        }
        .padding(.horizontal, DesignSystem.Spacing.xxLarge)
    }
    
    private var headerSection: some View {
        PharmaScoutLabelView()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    private var logoSection: some View {
        Image(.logoGPS)
            .resizable()
            .scaledToFit()
            .containerRelativeFrame(.horizontal) { width, _ in
                width * 0.7
            }
    }
    
    private var descriptionSection: some View {
        VStack(
            alignment: horizontalSizeClass == .compact ? .leading : .center,
            spacing: DesignSystem.Spacing.medium
        ) {
            Text("Find the medicine you need.")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("PharmaScout checks nearby pharmacies in real time and brings every availability response back to one place.")
                .foregroundStyle(.textSecondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: horizontalSizeClass == .compact ? .leading : .center
        )
    }
    
    private var buttonsSection: some View {
        VStack(spacing: DesignSystem.Spacing.xLarge) {
            PrimaryButtonView(title: "Get Started") {
                onGetStartedTapped()
            }
            .frame(maxWidth: 400)
            .frame(maxWidth: .infinity)
            
            ActionPromptView(actionTitle: "I already have an account") {
                onHaveAccountTapped()
            }
        }
    }
}

#Preview {
    WelcomeScreen(
        onGetStartedTapped: {},
        onHaveAccountTapped: {}
    )
}

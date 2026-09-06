//
//  WelcomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct WelcomeScreen: View {
    let authService: AuthService
    let googleAuthService: OAuthService
    let appleAuthService: OAuthService

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    init(authSerivce: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        self.authService = authSerivce
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    var body: some View {
        CustomNavStack {
            VStack {
                headerSection
                
                Spacer()
                
                logoSection
                
                Spacer()
                
                descriptionSection
                
                Spacer()
                
                buttonsSection
            }
            .customNavBarVisibility(false)
            .padding(.horizontal, Spacing.xxLarge)
        }
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
            spacing: Spacing.medium
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
        VStack(spacing: Spacing.xLarge) {
            CustomNavLink {
                SignUpScreen(
                    authService: authService,
                    googleAuthService: googleAuthService,
                    appleAuthService: appleAuthService
                )
            } label: {
                PrimaryButtonLabelView(title: "Get Started")
                    .frame(maxWidth: 400)
                    .frame(maxWidth: .infinity)
            }
            
            NavigationPromptView(actionTitle: "I already have an account") {
                SignInScreen(
                    authService: authService,
                    googleAuthService: googleAuthService,
                    appleAuthService: appleAuthService
                )
            }
        }
    }
}

#Preview {
    WelcomeScreen(
        authSerivce: MockAuthService.sample,
        googleAuthService: MockGoogleAuthService.sample,
        appleAuthService: MockAppleAuthService.sample
    )
}

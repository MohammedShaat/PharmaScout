//
//  AuthenticationFlowView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import SwiftUI

struct AuthenticationFlowView: View {
    private let authService: AuthService
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    private let initialRoute: AuthenticationRoute?

    @State private var vm: AuthenticationFlowViewModel
    
    init(
        authSerivce: AuthService,
        googleAuthService: OAuthService,
        appleAuthService: OAuthService,
        onboardingService: OnboardingService,
        initialRoute: AuthenticationRoute? = nil,
    ) {
        self.initialRoute = initialRoute
        self.authService = authSerivce
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        
        let router = AuthenticationFlowViewModel(
            onboardingService: onboardingService,
            root: initialRoute
        )
        self._vm = State(wrappedValue: router)
    }
    
    var body: some View {
        TypedCustomNavStack(path: $vm.path) {
            Group {
                if vm.showWelcomeScreen {
                    WelcomeScreen(
                        onGetStartedTapped: { vm.markWelcomeAsSeenAndShow(.signUp) },
                        onHaveAccountTapped: { vm.markWelcomeAsSeenAndShow(.signIn) }
                    )
                } else {
                    screen(for: vm.root)
                        .transition(.move(edge: .trailing))
                }
            }
            .customNavBarVisibility(false)
            .customNavigationDestination(for: AuthenticationRoute.self) { route in
                screen(for: route)
            }
            .animation(.default, value: vm.showWelcomeScreen)
        }
    }
    
    
    @ViewBuilder
    private func screen(for route: AuthenticationRoute) -> some View {
        switch route {
        case .signUp:
            SignUpScreen(
                authService: authService,
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService
            ) {
                vm.navigateTo(.signIn)
            }
            
        case .signIn:
            SignInScreen(
                authService: authService,
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService
            ) {
                vm.navigateTo(.signUp)
            } onForgotPasswordTapped: {
                vm.navigateTo(.forgotPassword)
            }
            
        case .forgotPassword:
            ForgotPasswordScreen(authSerivce: authService)
        }
    }
}

#Preview {
    AuthenticationFlowView(
        authSerivce: MockAuthService.sample,
        googleAuthService: MockGoogleAuthService.sample,
        appleAuthService: MockAppleAuthService.sample,
        onboardingService: MockOnboardingService.sample,
        initialRoute: nil
    )
}

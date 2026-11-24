//
//  AuthenticationFlowView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import SwiftUI

struct AuthenticationFlowView: View {
    private let dependencies: AppDependencies
    private let initialRoute: AuthenticationRoute?

    @State private var vm: AuthenticationFlowViewModel
    
    init(
        dependencies: AppDependencies,
        initialRoute: AuthenticationRoute? = nil,
    ) {
        self.initialRoute = initialRoute
        self.dependencies = dependencies
        
        let router = AuthenticationFlowViewModel(
            onboardingService: dependencies.onboardingService,
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
            .customNavBarVisibility(.root)
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
                authService: dependencies.authService,
                googleAuthService: dependencies.googleAuthService,
                appleAuthService: dependencies.appleAuthService
            ) {
                vm.navigateTo(.signIn)
            }
            
        case .signIn:
            SignInScreen(
                authService: dependencies.authService,
                googleAuthService: dependencies.googleAuthService,
                appleAuthService: dependencies.appleAuthService
            ) {
                vm.navigateTo(.signUp)
            } onForgotPasswordTapped: {
                vm.navigateTo(.forgotPassword)
            }
            
        case .forgotPassword:
            ForgotPasswordScreen(authSerivce: dependencies.authService)
        }
    }
}

#Preview {
    AuthenticationFlowView(
        dependencies: .uiTesting(),
        initialRoute: nil
    )
}

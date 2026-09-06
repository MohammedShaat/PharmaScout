//
//  ContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

struct RootView: View {
    private let router: AppRouter
    private let authService: AuthService
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    
    init(router: AppRouter, authService: AuthService, googleAuthService: OAuthService, appleAuthService: OAuthService) {
        self.router = router
        self.authService = authService
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    var body: some View {
        Group {
            switch router.destination {
            case .authentication:
                WelcomeScreen(authSerivce: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService)
                
            case .signIn:
                CustomNavStack {
                    SignInScreen(authService: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService)
                        .customNavBarVisibility(false)
                }
                
            case .resetPassword:
                ResetPasswordScreen(authSerivce: authService, router: router)

            case .main:
                PatientTabView(authService: authService)
            }
        }
    }
}

#Preview {
    let authService = MockAuthService.sample
    let router = AppRouter(authService: authService)
    
    
    RootView(
        router: router,
        authService: authService,
        googleAuthService: MockGoogleAuthService.sample,
        appleAuthService: MockAppleAuthService.sample		
    )
    .task {
        await router.subscribeToAuthStateChanges()
    }
}

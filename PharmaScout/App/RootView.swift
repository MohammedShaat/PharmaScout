//
//  ContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

struct RootView: View {
    let router: AppRouter
    let dependencies: AppDependencies
    
    var body: some View {
        Group {
            switch router.destination {
            case .loading:
                SessionLoadingScreen()
                
            case .authenticationFlow, .signIn:
                AuthenticationFlowView(dependencies: dependencies, initialRoute: router.destination == .signIn ? .signIn : nil)
                
            case .resetPassword:
                ResetPasswordScreen(authSerivce: dependencies.authService, onBackToSignInTapped: router.navigateToSignIn)
                
            case .authenticationFailure(let message):
                AuthenticationStateErrorScreen(errorMessage: message)
                
            case .patient(let user):
                PatientTabView(user: user, router: router, dependencies: dependencies)
                
            case .pharmacist(let user, let staffMembership):
                PharmacistTabView(user: user, router: router, staffMembership: staffMembership, dependencies: dependencies)
                
            case .admin(let user):
                AdminTabView(user: user, dependencies: dependencies)
                
            case .ownerApplicant(let user, let ownerApplicationSummary):
                OwnerApplicantTabView(
                    user: user, ownerApplicationSummary: ownerApplicationSummary, dependencies: dependencies)
            }
            
        }
    }
}

#if DEBUG
#Preview {
    let authService = MockAuthService.sample
    let router = AppRouter(authService: authService)
    
    
    RootView(
        router: router,
        dependencies: .uiTesting()
    )
    .task {
        await router.subscribeToAuthStateChanges()
    }
}
#endif

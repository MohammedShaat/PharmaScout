//
//  AuthenticationRouter.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import Foundation

@Observable
class AuthenticationFlowViewModel {
    private let onboardingService: OnboardingService
    
    var path: [AuthenticationRoute] = []
    var root: AuthenticationRoute
    
    private(set) var showWelcomeScreen: Bool
    
    init(onboardingService: OnboardingService, root: AuthenticationRoute?) {
        self.onboardingService = onboardingService
        self.root = root ?? .signIn
        self.showWelcomeScreen = root == nil && !onboardingService.hasSeenWelcome
    }
    
    func navigateTo(_ route: AuthenticationRoute) {
        if route == root {
            path.removeAll()
        } else if let index = path.lastIndex(of: route) {
            // Navigate back to it instead of pushing a duplicate if already in the stack
            path.removeLast(path.count - index - 1)
        } else {
            path.append(route)
        }
    }
    
    func markWelcomeAsSeenAndShow(_ route: AuthenticationRoute) {
        onboardingService.markWelcomeSeen()
        root = route
        showWelcomeScreen = false
    }
}

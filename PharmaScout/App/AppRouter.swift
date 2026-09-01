//
//  AppRouter.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//

import Foundation
import Supabase
import GoogleSignIn

@Observable
class AppRouter {
    private let authService: AuthService
    private(set) var destination: Destination = .authentication
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func handleUrl(_ url: URL) async {
        if GIDSignIn.sharedInstance.handle(url) {
            return
        }
        
        guard url.scheme == DeepLink.scheme,
              let deepLink = DeepLink(rawValue: (url.host() ?? "") + url.path())
        else {
            print("DeepLink-url is invalid\n", url)
            return
        }
        
        switch deepLink {
        case .emailConfirmation:
            try? await authService.handle(url: url, passwordReset: false)
        
        case .passwordReset:
            try? await authService.handle(url: url, passwordReset: true)
        }
        print("DeepLink-", deepLink)
    }
    
    func subscribeToAuthStateChanges() async {
        for await state in authService.authState {
            switch state {
            case .authenticated:
                destination = .main
            case .non:
                destination = .authentication
            case .passwordReset:
                destination = .resetPassword
            }
        }
    }
    
    func onPasswordResetSucceeed() {
        destination = .main
    }
    
    func navigateToSignIn() {
        destination = .signIn
    }
}

enum Destination {
    case authentication
    case signIn
    case resetPassword
    case main
}

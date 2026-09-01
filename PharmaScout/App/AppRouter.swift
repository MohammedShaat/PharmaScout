//
//  AppRouter.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//

import Foundation
import Supabase

@Observable
class AppRouter {
    private let authService: AuthService
    private(set) var destination: Destination = .authentication
    
    init(authService: AuthService) {
        self.authService = authService
        
        Task {
            try? await authService.signOut()
        }
    }
    
    func handleUrl(_ url: URL) {
        guard url.scheme == DeepLink.scheme,
              let deepLink = DeepLink(rawValue: (url.host() ?? "") + url.path())
        else {
            print("url is invalid\n", url)
            return
        }
        
        switch deepLink {
        case .emailConfirmation:
            authService.handle(url: url)
        }
    }
    
    func subscribeToAuthStateChanges() async {
        for await state in authService.authState {
            switch state {
            case .authenticated:
                destination = .main
            case .non:
                destination = .authentication
            }
        }
    }
}

enum Destination {
    case authentication
    case main
}

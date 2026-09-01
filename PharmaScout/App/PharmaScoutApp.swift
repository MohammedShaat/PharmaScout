//
//  PharmaScoutApp.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

@main
struct PharmaScoutApp: App {
    let authService: AuthService
    let googleAuthService: GoogleAuthService
    @State private var router: AppRouter
    
    init() {
        let authService = DefaultAuthService()
        self.authService = authService
        self.googleAuthService = DefaultGoogleAuthService()
        self._router = State(wrappedValue: AppRouter(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(router: router, authService: DefaultAuthService(), googleAuthService: googleAuthService)
                .onOpenURL { url in
                    Task {
                        await router.handleUrl(url)
                    }
                }
                .task {
                    await router.subscribeToAuthStateChanges()
                }
        }
    }
}

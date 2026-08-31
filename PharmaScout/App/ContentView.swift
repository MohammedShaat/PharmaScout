//
//  ContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

struct ContentView: View {
    let authService: AuthService
    @State private var router: AppRouter
    
    init(authService: AuthService) {
        self.authService = authService
        self._router = State(wrappedValue: AppRouter(authService: authService))
    }
    
    var body: some View {
        Group {
            switch router.destination {
            case .authentication:
                WelcomeScreen(authSerivce: authService)
            case .main:
                Text("Welcome to PharmaScount")
            }
        }
        .onOpenURL { url in
            router.handleUrl(url)
        }
        .task {
            await router.subscribeToAuthStateChanges()
        }
    }
}

#Preview {
    ContentView(authService: MockAuthService.sample)
}

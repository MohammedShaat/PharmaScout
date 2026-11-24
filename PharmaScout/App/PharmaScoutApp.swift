//
//  PharmaScoutApp.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

@main
struct PharmaScoutApp: App {
    private let dependencies: AppDependencies
    
    @State private var router: AppRouter
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    init() {
        #if DEBUG
        dependencies = LaunchEnvironment.isUITesting ? .uiTesting() : .live()
        #else
        dependencies = .live()
        #endif
        self._router = State(wrappedValue: AppRouter(authService: dependencies.authService))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(router: router, dependencies: dependencies)
                .onOpenURL { url in
                    Task { await router.handleUrl(url) }
                }
                .task { await router.subscribeToAuthStateChanges() }
                .task { await dependencies.pushTokenCoordinator.observeToken(appDelegate.tokenStream) }
                .task { await dependencies.pushTokenCoordinator.observeAuthState(dependencies.authService.authStateStream()) }
                .task { await router.observeNotificationRoute(appDelegate.notificationStream) }
                .task {
                    guard !LaunchEnvironment.isUITesting else { return }
                    await CrashReportingManager.observeAuthChanges(dependencies.authService.authStateStream())
                }
        }
    }
}

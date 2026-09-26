//
//  PharmaScoutApp.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

@main
struct PharmaScoutApp: App {
    private let authService: AuthService = DefaultAuthService()
    private let googleAuthService: OAuthService = DefaultGoogleAuthService()
    private let appleAuthService: OAuthService = DefaultAppleAuthService()
    private let drugService: DrugService = DefaultDrugService()
    private let searchRequestService: SearchRequestService = DefaultSearchRequestService()
    private let locationService: LocationService = DefaultLocationService()
    private let pharmacySerivce: PharmacyService = DefaultPharmacyService()
    private let directionsService: DirectionsService = DefaultDirectionsService()
    
    @State private var router: AppRouter
    
    init() {
        self._router = State(wrappedValue: AppRouter(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                router: router,
                authService: DefaultAuthService(),
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService,
                drugService: drugService,
                searchRequestService: searchRequestService,
                locationService: locationService,
                pharmacySerivce: pharmacySerivce,
                directionsService: directionsService
            )
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

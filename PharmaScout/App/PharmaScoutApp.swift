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
    private let googleAuthService: OAuthService
    private let appleAuthService: OAuthService
    private let drugService: DrugService = DefaultDrugService()
//    private let searchRequestService: SearchRequestService = DefaultSearchRequestService()
    private let searchRequestService: SearchRequestService = MockSearchRequestService()
    private let locationService: LocationService = DefaultLocationService()
    private let pharmacySerivce: PharmacyService = DefaultPharmacyService()
    private let directionsService: DirectionsService = DefaultDirectionsService()
    private let inquiryService: InquiryService = DefaultInquiryService()
    private let analyticsService: AnalyticsService = DefaultAnalyticsService()
    private let deviceTokenService: DeviceTokenService = DefaultDeviceTokenService()
    private let appConfigService: AppConfigService = DefaultAppConfigService()
    private let ownerApplicationService: OwnerApplicationService = DefaultOwnerApplicationService()
    private let geocodingService: GeocodingService = DefaultGeocodingService()
    private let placeSearchService: PlaceSearchService = DefaultPlaceSearchService(region: nil)
    private let onboardingService: OnboardingService = DefaultOnboardingService()
    private let appleReauthenticationService: AppleReauthenticationService
    private let googleReauthenticationService: GoogleReauthenticationService
    
    @State private var router: AppRouter
    private let pushTokenCooridnator: PushTokenCoordinator
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    init() {
        self._router = State(wrappedValue: AppRouter(authService: authService))
        self.pushTokenCooridnator = PushTokenCoordinator(deviceTokenService: deviceTokenService)
        
        let appleService = DefaultAppleAuthService()
        self.appleAuthService = appleService
        self.appleReauthenticationService = appleService
        
        let googleService = DefaultGoogleAuthService()
        self.googleAuthService = googleService
        self.googleReauthenticationService = googleService
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                router: router,
                authService: authService,
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService,
                drugService: drugService,
                searchRequestService: searchRequestService,
                locationService: locationService,
                pharmacySerivce: pharmacySerivce,
                directionsService: directionsService,
                inquiryService: inquiryService,
                analyticsService: analyticsService,
                pushTokenCoordinator: pushTokenCooridnator,
                appConfigService: appConfigService,
                ownerApplicationService: ownerApplicationService,
                geocodingService: geocodingService,
                placeSearchService: placeSearchService,
                onboardingService: onboardingService,
                appleReauthenticationService: appleReauthenticationService,
                googleReauthenticationService: googleReauthenticationService
            )
            .onOpenURL { url in
                Task { await router.handleUrl(url) }
            }
            .task { await router.subscribeToAuthStateChanges() }
            .task { await pushTokenCooridnator.observeToken(appDelegate.tokenStream) }
            .task { await pushTokenCooridnator.observeAuthState(authService.authStateStream()) }
            .task { await router.observeNotificationRoute(appDelegate.notificationStream) }
            .task { await CrashReportingManager.observeAuthChanges(authService.authStateStream()) }
        }
    }
}

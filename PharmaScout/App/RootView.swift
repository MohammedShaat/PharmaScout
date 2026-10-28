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
    private let drugService: DrugService
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    private let pharmacySerivce: PharmacyService
    private let directionsService: DirectionsService
    private let inquiryService: InquiryService
    private let analyticsService: AnalyticsService
    private let pushTokenCoordinator: PushTokenCoordinator
    private let appConfigService: AppConfigService
    private let ownerApplicationService: OwnerApplicationService
    private let geocodingService: GeocodingService
    private let placeSearchService: PlaceSearchService
    private let onboardingService: OnboardingService
    
    init(
        router: AppRouter,
        authService: AuthService,
        googleAuthService: OAuthService,
        appleAuthService: OAuthService,
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        pharmacySerivce: PharmacyService,
        directionsService: DirectionsService,
        inquiryService: InquiryService,
        analyticsService: AnalyticsService,
        pushTokenCoordinator: PushTokenCoordinator,
        appConfigService: AppConfigService,
        ownerApplicationService: OwnerApplicationService,
        geocodingService: GeocodingService,
        placeSearchService: PlaceSearchService,
        onboardingService: OnboardingService
    ) {
        self.router = router
        self.authService = authService
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.drugService = drugService
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.pharmacySerivce = pharmacySerivce
        self.directionsService = directionsService
        self.inquiryService = inquiryService
        self.analyticsService = analyticsService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.appConfigService = appConfigService
        self.ownerApplicationService = ownerApplicationService
        self.geocodingService = geocodingService
        self.placeSearchService = placeSearchService
        self.onboardingService = onboardingService
    }
    
    var body: some View {
        Group {
            switch router.destination {
            case .loading:
                SessionLoadingScreen()
                
            case .authenticationFlow, .signIn:
                AuthenticationFlowView(authSerivce: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService, onboardingService: onboardingService, initialRoute: router.destination == .signIn ? .signIn : nil)
                
            case .resetPassword:
                ResetPasswordScreen(authSerivce: authService, onBackToSignInTapped: router.navigateToSignIn)
                
            case .authenticationFailure(let message):
                AuthenticationStateErrorScreen(errorMessage: message)
                
            case .patient(let user):
                PatientTabView(user: user, router: router, authService: authService, drugService: drugService, searchRequestService: searchRequestService, locationService: locationService, pharmacySerivce: pharmacySerivce, directionsService: directionsService, pushTokenCoordinator: pushTokenCoordinator, appConfigService: appConfigService, ownerApplicationService: ownerApplicationService)
            
            case .pharmacist(let user, let staffMembership):
                PharmacistTabView(user: user, router: router, staffMembership: staffMembership, authService: authService, inquiryService: inquiryService, drugService: drugService, pharmacyService: pharmacySerivce, analyticsService: analyticsService, pushTokenCoordinator: pushTokenCoordinator)
                
            case .admin(let user):
                AdminTabView(user: user, authService: authService, pushTokenCoordinator: pushTokenCoordinator, ownerApplicationService: ownerApplicationService, pharmacyService: pharmacySerivce)
                
            case .ownerApplicant(let user, let ownerApplicationSummary):
                OwnerApplicantTabView(user: user, ownerApplicationSummary: ownerApplicationSummary, authService: authService, pushTokenCoordinator: pushTokenCoordinator, ownerApplicationService: ownerApplicationService, pharmacyService: pharmacySerivce, geocodingService: geocodingService, placeSearchService: placeSearchService, locationService: locationService)
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
        appleAuthService: MockAppleAuthService.sample,
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        pharmacySerivce: MockPharmacyService.sample,
        directionsService: MockDirectionsSrevice.sample,
        inquiryService: MockInquiryService.sample,
        analyticsService: MockAnalyticsService.sample,
        pushTokenCoordinator: .sample,
        appConfigService: MockAppConfigService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample,
        geocodingService: MockGeocodingService.sample,
        placeSearchService: MockPlaceSearchService.sample,
        onboardingService: MockOnboardingService.sample
    )
    .task {
        await router.subscribeToAuthStateChanges()
    }
}

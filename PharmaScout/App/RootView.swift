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
        ownerApplicationService: OwnerApplicationService
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
    }
    
    var body: some View {
        Group {
            switch router.destination {
            case .loading:
                SessionLoadingScreen()
                
            case .authentication:
                WelcomeScreen(authSerivce: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService)
                
            case .signIn:
                CustomNavStack {
                    SignInScreen(authService: authService, googleAuthService: googleAuthService, appleAuthService: appleAuthService)
                        .customNavBarVisibility(false)
                }
                
            case .resetPassword:
                ResetPasswordScreen(authSerivce: authService, router: router)
                
            case .authStateError(let error):
                AuthenticationStateErrorScreen(error: error)
                
            case .patient:
                PatientTabView(router: router, authService: authService, drugService: drugService, searchRequestService: searchRequestService, locationService: locationService, pharmacySerivce: pharmacySerivce, directionsService: directionsService, pushTokenCoordinator: pushTokenCoordinator, appConfigService: appConfigService)
            
            case .pharmacist:
                PharmacistTabView(router: router, authService: authService, inquiryService: inquiryService, drugService: drugService, pharmacyService: pharmacySerivce, analyticsService: analyticsService, pushTokenCoordinator: pushTokenCoordinator)
                
            case .admin:
                AdminTabView(authService: authService, pushTokenCoordinator: pushTokenCoordinator, ownerApplicationService: ownerApplicationService)
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
        ownerApplicationService: MockOwnerApplicationService.sample
    )
    .task {
        await router.subscribeToAuthStateChanges()
    }
}

//
//  AppDependencies.swift
//  PharmaScout
//
//  Created by Mohammed on 11/24/26.
//

import Foundation

struct AppDependencies {
    let authService: AuthService
    let googleAuthService: OAuthService
    let appleAuthService: OAuthService
    let drugService: DrugService
    let searchRequestService: SearchRequestService
    let locationService: LocationService
    let pharmacyService: PharmacyService
    let directionsService: DirectionsService
    let inquiryService: InquiryService
    let analyticsService: AnalyticsService
    let deviceTokenService: DeviceTokenService
    let pushTokenCoordinator: PushTokenCoordinator
    let appConfigService: AppConfigService
    let ownerApplicationService: OwnerApplicationService
    let geocodingService: GeocodingService
    let placeSearchService: PlaceSearchService
    let onboardingService: OnboardingService
    let appleReauthenticationService: AppleReauthenticationService
    let googleReauthenticationService: GoogleReauthenticationService
    
    static func live() -> AppDependencies {
        let appleService = DefaultAppleAuthService()
        let googleService = DefaultGoogleAuthService()
        let deviceTokenService = DefaultDeviceTokenService()

        return AppDependencies(
            authService: DefaultAuthService(),
            googleAuthService: googleService,
            appleAuthService: appleService,
            drugService: DefaultDrugService(),
            searchRequestService: DefaultSearchRequestService(),
            locationService: DefaultLocationService(),
            pharmacyService: DefaultPharmacyService(),
            directionsService: DefaultDirectionsService(),
            inquiryService: DefaultInquiryService(),
            analyticsService: DefaultAnalyticsService(),
            deviceTokenService: deviceTokenService,
            pushTokenCoordinator: PushTokenCoordinator(deviceTokenService: deviceTokenService),
            appConfigService: DefaultAppConfigService(),
            ownerApplicationService: DefaultOwnerApplicationService(),
            geocodingService: DefaultGeocodingService(),
            placeSearchService: DefaultPlaceSearchService(region: nil),
            onboardingService: DefaultOnboardingService(),
            appleReauthenticationService: appleService,
            googleReauthenticationService: googleService
        )
    }
    
    #if DEBUG
    static func uiTesting() -> AppDependencies {
        let appleService = MockAppleAuthService()
        let googleService = MockGoogleAuthService()
        let deviceTokenService = MockDeviceTokenService()

        return AppDependencies(
            authService: MockAuthService(),
            googleAuthService: googleService,
            appleAuthService: appleService,
            drugService: MockDrugService(),
            searchRequestService: MockSearchRequestService(requestLimit: 2, delay: .zero, activeSearchCount: 0),
            locationService: MockLocationService(),
            pharmacyService: MockPharmacyService(),
            directionsService: MockDirectionsSrevice(),
            inquiryService: MockInquiryService(),
            analyticsService: MockAnalyticsService(),
            deviceTokenService: deviceTokenService,
            pushTokenCoordinator: PushTokenCoordinator(deviceTokenService: deviceTokenService),
            appConfigService: MockAppConfigService(),
            ownerApplicationService: MockOwnerApplicationService(),
            geocodingService: MockGeocodingService(),
            placeSearchService: MockPlaceSearchService(),
            onboardingService: MockOnboardingService(),
            appleReauthenticationService: appleService,
            googleReauthenticationService: googleService
        )
    }
    #endif
}

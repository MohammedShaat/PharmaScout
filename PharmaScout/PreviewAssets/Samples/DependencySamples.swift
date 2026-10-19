//
//  DependencySamples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import Foundation

extension MockAuthService {
    static let sample = MockAuthService()
}

extension MockGoogleAuthService {
    static let sample = MockGoogleAuthService()
}

extension MockAppleAuthService {
    static let sample = MockAppleAuthService()
}

extension MockDrugService {
    static let sample = MockDrugService()
}

extension MockSearchRequestService {
    static let sample = MockSearchRequestService()
}

extension MockLocationService {
    static let sample = MockLocationService()
}

extension MockPharmacyService {
    static let sample = MockPharmacyService()
}

extension MockDirectionsSrevice {
    static let sample = MockDirectionsSrevice()
}

extension MockInquiryService {
    static let sample = MockInquiryService()
}

extension MockAnalyticsService {
    static let sample = MockAnalyticsService()
}

extension MockDeviceTokenService {
    static let sample = MockDeviceTokenService()
}

extension MockAppConfigService {
    static let sample = MockAppConfigService()
}

extension MockOwnerApplicationService {
    static let sample = MockOwnerApplicationService()
}

extension MockGeocodingService {
    static let sample = MockGeocodingService()
}

extension MockPlaceSearchService {
    static let sample = MockPlaceSearchService()
}

extension SignUpViewModel {
    static let sample = SignUpViewModel(
        authService: MockAuthService.sample,
        googleAuthService: MockGoogleAuthService.sample,
        appleAuthService: MockAppleAuthService.sample
    )
}

extension PatientTabViewModel {
    static let sample = PatientTabViewModel()
}

extension PharmacistTabViewModel {
    static let sample = PharmacistTabViewModel(staffMembership: .samples[0])
}

extension OwnerApplicantTabViewModel {
    static let sample = OwnerApplicantTabViewModel(ownerApplicationSummary: .samples[0])
}

extension AppRouter {
    static let sample = AppRouter(authService: MockAuthService.sample)
}

extension PushTokenCoordinator {
    static let sample = PushTokenCoordinator(deviceTokenService: MockDeviceTokenService.sample)
}

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
    static let sample = PharmacistTabViewModel(authService: MockAuthService.sample)
}

extension AppRouter {
    static let sample = AppRouter(authService: MockAuthService.sample)
}

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

extension SignUpViewModel {
    static let sample = SignUpViewModel(authService: MockAuthService.sample, googleAuthService: MockGoogleAuthService.sample)
}

extension AppRouter {
    static let sample = AppRouter(authService: MockAuthService.sample)
}

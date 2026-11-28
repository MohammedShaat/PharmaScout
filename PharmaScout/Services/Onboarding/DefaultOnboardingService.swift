//
//  DefaultOnboardingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import Foundation

struct DefaultOnboardingService: OnboardingService {
    private enum Keys {
        static let hasSeenWelcome = "hasSeenWelcome"
    }

    private let userDefaults = UserDefaults.standard
    
    var hasSeenWelcome: Bool {
        userDefaults.bool(forKey: Keys.hasSeenWelcome)
    }
    
    func markWelcomeSeen() {
        userDefaults.set(true, forKey: Keys.hasSeenWelcome)
    }
}

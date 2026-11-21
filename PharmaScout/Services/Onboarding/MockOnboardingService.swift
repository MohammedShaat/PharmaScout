//
//  MockOnboardingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import Foundation

class MockOnboardingService: OnboardingService {
    private(set) var hasSeenWelcome: Bool
    
    init(hasSeenWelcome: Bool = false) {
        self.hasSeenWelcome = hasSeenWelcome
    }
    
    func markWelcomeSeen() {
        hasSeenWelcome = true
    }
}

//
//  OnboardingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import Foundation

protocol OnboardingService {
    var hasSeenWelcome: Bool { get }
    func markWelcomeSeen()
}

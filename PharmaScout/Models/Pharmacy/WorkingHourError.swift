//
//  WorkingHourError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/27/26.
//

import Foundation

enum WorkingHourError: AppError {
    case invalidOvernightHours
    case invalidEqualHours

    var errorDescription: String {
        switch self {
        case .invalidOvernightHours:
            return "Overnight working hours must end at midnight."

        case .invalidEqualHours:
            return "Opening and closing times cannot be equal unless the pharmacy operates 24 hours."
        }
    }
}

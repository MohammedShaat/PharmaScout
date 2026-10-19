//
//  InvalidInputError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

enum InvalidInputError: AppError {
    case invalidFormat
    case missingRequiredInput
    case invalidValue

    var errorDescription: String {
        switch self {
        case .invalidFormat:
            "The input format is invalid"
        case .missingRequiredInput:
            "A required input is missing"
        case .invalidValue:
            "The provided value is invalid"
        }
    }
}

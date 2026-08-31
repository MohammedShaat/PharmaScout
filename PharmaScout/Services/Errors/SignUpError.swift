//
//  SignUpError.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

enum SignUpError: AppError {
    case nameInvalid
    case emailInvalid
    case emailAlreadyExists
    case passwordNotMatch
    case missingEmail
    case weakPassword
    case emailRateLimit
    case unknown(Error)

    var errorDescription: String {
        switch self {
        case .nameInvalid: "Please enter your first and last name."
        case .emailInvalid: "Please enter a valid email address."
        case .emailAlreadyExists: "This email is already associated with an account."
        case .passwordNotMatch: "Passwords do not match."
        case .weakPassword: "Please enter a password with at least 8 characters."
        case .emailRateLimit: "You’ve requested too many verification emails. Please wait before trying again."
        case .missingEmail: "Email is missing"
        case .unknown: "Something went wrong. Please try again."
        }
    }
}

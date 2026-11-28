//
//  AccountDeletionError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/31/26.
//

import Foundation

enum AccountDeletionError: AppError {
    case reauthenticationRequired(providers: [AuthProvider])
    case reauthenticationFailed(AccountDeletionErrorCode)
    case blocked([AccountDeletionBlocker])
    case generic

    var errorDescription: String {
        switch self {
        case .reauthenticationRequired(let providers):
            let names = providers.map(\.displayName)
            return "For security reasons, you must reauthenticate using \(names.joinedWithOr()) before deleting your account."

        case .reauthenticationFailed(let code):
            switch code {
            case .reauthenticationExpired:
                return "Your authentication session has expired. Please try again."

            case .appleAccountMismatch:
                return "The Apple account used for authorization does not match the account associated with your profile."

            case .googleAccountMismatch:
                return "The Google account used for authorization does not match the account associated with your profile."

            case .invalidPassword:
                return "The password you entered is incorrect."

            case .tooManyAttempts:
                return "Too many attempts. Please wait before trying again."

            case .reauthenticationFailed:
                return "Reauthentication failed. Please try again."

            case .deletionFailed:
                return "Account deletion failed. Please try again later."
            }

        case .blocked:
            return "You must resolve the account deletion requirements before deleting your account."

        case .generic:
            return "Something went wrong. Please try again later."
        }
    }
}

enum AccountDeletionBlocker: String, Codable {
    case ownsActivePharmacy = "owns_active_pharmacy"
}

enum AccountDeletionErrorCode: String, Decodable {
    case reauthenticationExpired = "reauthentication_expired"
    case reauthenticationFailed = "reauthentication_failed"

    case appleAccountMismatch = "apple_account_mismatch"
    case googleAccountMismatch = "google_account_mismatch"

    case invalidPassword = "invalid_password"
    case tooManyAttempts = "too_many_attempts"

    case deletionFailed = "deletion_failed"
}

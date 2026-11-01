//
//  AccountDeletionError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/31/26.
//

import Foundation

enum AccountDeletionError: AppError {
    case blocked([AccountDeletionBlocker])
    
    var errorDescription: String {
        switch self {
        case .blocked:
            "You must resolve the account deletion requirements before deleting your account."
        }
    }
}


enum AccountDeletionBlocker: String, Sendable {
    case ownsActivePharmacy = "owns_active_pharmacy"
}

//
//  PharmacyOwnershipError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

enum OwnerApplicationError: AppError {
    case codeAlreadyUsed
    case alreadyPendingOrApproved
    
    var errorDescription: String {
        switch self {
        case .codeAlreadyUsed:
            "This invitation code has already been used."
        case .alreadyPendingOrApproved:
            "You already have a pending or approved application."
            
        }
    }
}

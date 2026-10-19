//
//  PharmacyCreationError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

enum PharmacyCreationError: AppError {
    case alreadyHasPharmacy

    var errorDescription: String {
        switch self {
        case .alreadyHasPharmacy:
            "You already have a pharmacy registered"
        }
    }
}

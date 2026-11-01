//
//  PharmacyJoinError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

enum PharmacyJoinError: AppError {
    case alreadyPharmacyMember
    case alreadyMemberOfAnotherPharmacy

    var errorDescription: String {
        switch self {
        case .alreadyPharmacyMember:
            "You’re already a member of this pharmacy"
        case .alreadyMemberOfAnotherPharmacy:
            "You already belong to another pharmacy"
        }
    }
}

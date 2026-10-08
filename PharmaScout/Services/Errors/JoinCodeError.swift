//
//  JoinCodeError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import Foundation

enum JoinCodeError: AppError {
    case invalidJoinCode
    case revokedJoinCode
    case expiredJoinCode
    case alreadyPharmacyMember
    
    var errorDescription: String {
        switch self {
        case .invalidJoinCode:
            "The code is invalid"
        case .revokedJoinCode:
            "This code has been deactivated"
        case .expiredJoinCode:
            "This code has expired"
        case .alreadyPharmacyMember:
            "You’re already a member of this pharmacy"
        }
    }
}

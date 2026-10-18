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
    
    var errorDescription: String {
        switch self {
        case .invalidJoinCode:
            "The code is invalid"
        case .revokedJoinCode:
            "This code has been deactivated"
        case .expiredJoinCode:
            "This code has expired"
        }
    }
}

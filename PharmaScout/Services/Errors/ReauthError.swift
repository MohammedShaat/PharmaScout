//
//  ReauthError.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//

import Foundation

enum ReauthError: AppError {
    case canceled
    case unavailable

    var errorDescription: String {
        switch self {
        case .canceled:
            "Reauthentication was canceled."
        case .unavailable:
            "Reauthentication is currently unavailable. Please try again later."
        }
    }
}

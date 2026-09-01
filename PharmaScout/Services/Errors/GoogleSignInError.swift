//
//  GoogleSignInError.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation

enum GoogleSignInError: AppError {
    case canceled
    case noExistingCredentials
    case presentationContextUnavailable
    case refreshTokenExpired
    case idTokenUnavailable
    case unknow(Error)
    
    var errorDescription: String {
        switch self {
        case .canceled: "Signing was canceled. You can try again whenever you're ready."
        case .noExistingCredentials: "We couldn't find your Google sign-in information. Please try signing in again."
        case .refreshTokenExpired: "Your Google sign-in session has expired. Please sign in again."
        case .presentationContextUnavailable: "We couldn’t start the sign-in process. Please try again."
        default: "We couldn't sign you in with Google. Please try again."
        }
    }
}

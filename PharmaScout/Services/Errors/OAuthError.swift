//
//  GoogleSignInError.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation

enum OAuthError: AppError {
    case canceled(OAuthProvider)
    case noExistingCredentials(OAuthProvider)
    case presentationContextUnavailable(OAuthProvider)
    case idTokenUnavailable(OAuthProvider)
    case refreshTokenExpired(OAuthProvider)
    case failed(OAuthProvider)
    case invalidResponse(OAuthProvider)
    case unknow(Error)
    
    var errorDescription: String {
        switch self {
        case .noExistingCredentials(let provider): "We couldn't find your \(provider.rawValue) sign-in information. Please try signing in again."
        case .refreshTokenExpired(let provider): "Your \(provider.rawValue) sign-in session has expired. Please sign in again."
        case .invalidResponse(let provider): "Invalid response from \(provider.rawValue). Please try again."
        default: "We couldn't sign you in. Please try again."
        }
    }
}

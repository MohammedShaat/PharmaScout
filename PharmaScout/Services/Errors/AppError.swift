//
//  AppErros.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//


import Foundation

protocol AppError: LocalizedError {
    var errorDescription: String { get }
}


extension AppError {
    func handle(_ error: Error) -> AppError? {
        switch error {
        case let authError as AppAuthError:
            print("Failed to sign in with Google (AuthError): ", authError)
            return authError
            
        case let oAutherror as OAuthError:
            if case .canceled = oAutherror {
                return nil
            } else {
                print("Failed to sign in with Google (OAuthError): ", oAutherror)
                return oAutherror
            }
            
        case let networkError as NetworkError:
            print("Failed to sign in with Google (NetworkError): ", networkError)
            return networkError
            
        default:
            print("Failed to sign in with Google\n", error)
            return UnknownError.unKnown(error)
        }
    }
}

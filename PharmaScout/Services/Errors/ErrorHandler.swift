//
//  ErrorHandler.swift
//  PharmaScout
//
//  Created by Mohammed on 9/5/26.
//

import Foundation

enum ErrorHandler {
    static func handle(_ error: Error) -> AppError? {
        switch error {
        case let oAutherror as OAuthError:
            if case .canceled = oAutherror {
                return nil
            } else {
                return oAutherror
            }
            
        case let appError as AppError:
            return appError
            
        default:
            return UnknownError.unKnown(error)
        }
    }
}

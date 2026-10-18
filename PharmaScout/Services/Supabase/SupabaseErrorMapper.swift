//
//  SupabaseErrorMapper.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation
import Helpers
import Auth

enum SupabaseErrorMapper {
    static func mapAuthError(_ error: Error) -> Error {
        switch error {
        case let authError as AuthError:
            mapAuthErrorToAppError(authError)
            
        case let urlError as URLError:
            NetworkError.init(from: urlError)
            
        default:
            error
        }
    }
    
    static func mapDatabseError(_ error: Error) -> Error {
        switch error {
        case let urlError as URLError:
            NetworkError.init(from: urlError)
            
        case let pgError as PostgrestError:
            mapPostgrestErrorToAppError(pgError)
            
        default:
            error
        }
    }
}

extension SupabaseErrorMapper {
    static private func mapAuthErrorToAppError(_ error: AuthError) -> AppAuthError {
        switch error.errorCode {
        case .emailExists: .emailAlreadyExists
            
        case .weakPassword: .weakPassword
            
        case .overEmailSendRateLimit: .emailRateLimit
            
        case .emailNotConfirmed: .emailNotConfirmed
            
        case .invalidCredentials: .invalidCredentials
            
        case .overRequestRateLimit: .overRequestRateLimit
            
        case .samePassword: .samePassword
            
        default: .unknown(error)
            
        }
    }
    
    static private func mapPostgrestErrorToAppError(_ error: PostgrestError) -> AppError {
        switch error.code {
        // MARK: Invitation code error
        case "P1001": JoinCodeError.invalidJoinCode
        
        case "P1002": JoinCodeError.revokedJoinCode
        
        case "P1003": JoinCodeError.expiredJoinCode
        
            
        // MARK: Join pharmacy error
        case "P2001": PharmacyJoinError.alreadyPharmacyMember
            
        
        // MARK: Expand search
        case "P5001": ContinueSearchError.searchIsNotAwaitingContinuation
        
        case "P5002": ContinueSearchError.radiusExceedsMaximum
            
            
        
        // MARK: Pharmacy Ownership error
        case "P3001": OwnerApplicationError.codeAlreadyUsed
            
        case "P3002": OwnerApplicationError.alreadyPendingOrApproved
        
        
        default: UnknownError.unKnown(error)
        }
    }
}

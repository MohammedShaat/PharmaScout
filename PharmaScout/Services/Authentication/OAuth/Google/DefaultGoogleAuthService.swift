//
//  googleAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation
import GoogleSignIn
import UIKit

struct DefaultGoogleAuthService: OAuthService {
    func signIn(viewController vc: UIViewController) async throws -> OAuthCredential {
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else { throw OAuthError.idTokenUnavailable(.google) }
            let accessToken = user.accessToken.tokenString
            
            return OAuthCredential(provider: .google, idToken: idToken, accessToken: accessToken)
            
        } catch let googleError as GIDSignInError {
            throw mapGIDSignInError(googleError)
            
        } catch let urlError as URLError {
            throw NetworkError(from: urlError)
            
        }
    }
}

extension DefaultGoogleAuthService {
    private func mapGIDSignInError(_ error: GIDSignInError) -> OAuthError {
        switch error.code {
        case .canceled: .canceled(.google)
        case .hasNoAuthInKeychain: .noExistingCredentials(.google)
        case.refreshTokenExpired: .refreshTokenExpired(.google)
        default: .unknow(error)
        }
    }
}

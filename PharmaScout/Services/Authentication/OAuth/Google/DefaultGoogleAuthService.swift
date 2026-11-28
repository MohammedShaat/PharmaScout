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
        let (idToken, accessToken) = try await getTokens(viewController: vc, accessTokenRequired: true)
        return OAuthCredential(provider: .google, idToken: idToken, accessToken: accessToken)
    }
    
    private func getTokens(viewController vc: UIViewController, accessTokenRequired: Bool) async throws -> (idToken: String, accessToken: String?) {
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else { throw OAuthError.idTokenUnavailable(.google) }
            let accessToken = accessTokenRequired ? user.accessToken.tokenString : nil
            
            return (idToken, accessToken)
            
        } catch let googleError as GIDSignInError {
            throw mapGIDSignInError(googleError)
            
        } catch let urlError as URLError {
            throw NetworkError(from: urlError)
            
        }
    }
}

extension DefaultGoogleAuthService: GoogleReauthenticationService {
    func idToken(viewController vc: UIViewController) async throws -> String {
        try await getTokens(viewController: vc, accessTokenRequired: false).idToken
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

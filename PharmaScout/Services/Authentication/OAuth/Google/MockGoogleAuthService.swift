//
//  googleAuthServiceProtocol.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation
import UIKit

struct MockGoogleAuthService: GoogleAuthService {
    func signIn(viewController vc: UIViewController) async throws -> OAuthCredential {
        OAuthCredential(provider: .google, idToken: "", accessToken: nil)
    }
}

//
//  MockAppleAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/5/26.
//

import Foundation
import UIKit

struct MockAppleAuthService: OAuthService {
    func signIn(viewController vc: UIViewController) async throws -> OAuthCredential {
        OAuthCredential(provider: .apple, idToken: "", nonce: "", fullName: "")
    }
}


// MARK: - Reauthentication
extension MockAppleAuthService: AppleReauthenticationService {
    func authorizationCode(viewController vc: UIViewController) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return "mock-authorization-code"
    }
}

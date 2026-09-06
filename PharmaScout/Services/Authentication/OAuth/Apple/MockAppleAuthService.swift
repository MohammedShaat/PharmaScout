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
        OAuthCredential(provider: .apple, idToken: "", nonce: "")
    }
}

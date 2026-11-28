//
//  googleAuthServiceProtocol.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation
import UIKit

protocol OAuthService {
    func signIn(viewController vc: UIViewController) async throws -> OAuthCredential
}

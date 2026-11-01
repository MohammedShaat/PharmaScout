//
//  AppleReauthenticationService.swift
//  PharmaScout
//
//  Created by Mohammed on 11/1/26.
//

import Foundation
import UIKit

protocol AppleReauthenticationService {
    func authorizationCode(viewController: UIViewController) async throws -> String
}

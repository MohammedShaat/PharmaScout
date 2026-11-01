//
//  GoogleReauthenticationService.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//

import Foundation
import UIKit

protocol GoogleReauthenticationService {
    func idToken(viewController vc: UIViewController) async throws -> String
}

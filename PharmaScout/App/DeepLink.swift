//
//  DeepLink.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//

import Foundation
import Playgrounds

nonisolated
enum DeepLink: String {
    static let scheme = "pharmascout"
    
    case emailConfirmation = "auth/email-confirmation"
    case passwordReset = "auth/password-reset"
    
    var url: URL {
        URL(string: "\(Self.scheme)://\(rawValue)")!
    }
}

#Playground {
    _ = DeepLink.emailConfirmation.url.absoluteString
}

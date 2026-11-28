//
//  ReauthCredential.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//

import Foundation

enum ReauthCredential: Encodable {
    case apple(code: String)
    case google(idToken: String)
    case email(password: String)
}


extension ReauthCredential {
    enum CodingKeys: String, CodingKey {
        case provider, code, idToken, password
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .apple(let code):
            try container.encode("apple", forKey: .provider)
            try container.encode(code, forKey: .code)
        case .google(let idToken):
            try container.encode("google", forKey: .provider)
            try container.encode(idToken, forKey: .idToken)
        case .email(let password):
            try container.encode("email", forKey: .provider)
            try container.encode(password, forKey: .password)
        }
    }
}

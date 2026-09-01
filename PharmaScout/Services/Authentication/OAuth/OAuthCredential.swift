//
//  GoogleCredential.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation

struct OAuthCredential {
    let provider: OAuthProvider
    let idToken: String
    let accessToken: String?
    let nonce: String?
    
    init(provider: OAuthProvider, idToken: String, accessToken: String?) {
        self.provider = provider
        self.idToken = idToken
        self.accessToken = accessToken
        self.nonce = nil
    }
    
    init(provider: OAuthProvider, idToken: String, accessToken: String?, nonce: String) {
        self.provider = provider
        self.idToken = idToken
        self.accessToken = accessToken
        self.nonce = nonce
    }
}

enum OAuthProvider {
    case google
    case apple
}

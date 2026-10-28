//
//  AuthState.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//


import Foundation
import Supabase

enum AuthState {
    case authenticated(AuthSession)
    case non
    case signedOut
    case passwordReset
    case failed(Error)
}

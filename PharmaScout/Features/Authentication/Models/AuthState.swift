//
//  AuthState.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//


import Foundation
import Supabase

enum AuthState {
    case authenticated
    case non
    case passwordReset
}

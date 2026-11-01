//
//  AuthProvider.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//


import Foundation

enum AuthProvider: String, Codable, Identifiable {
    case apple
    case google
    case email
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .apple: "Apple"
        case .google: "Google"
        case .email: "email and password"
        }
    }
}
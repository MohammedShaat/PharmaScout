//
//  User.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

struct AppUser: Codable {
    let id: String
    let fullName: String?
    let email: String?
    
    var firstName: String? {
        fullName?.components(separatedBy: .whitespaces).first
    }
}

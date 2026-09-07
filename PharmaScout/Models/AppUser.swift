//
//  User.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

struct AppUser {
    let fullName: String?
    let email: String?
    
    var firstName: String? {
        fullName?.components(separatedBy: .whitespaces).first
    }
}

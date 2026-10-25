//
//  AppUser+AuthUser.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import Foundation
import Auth

extension AppUser {
    init(from user: User) {
        self.id = user.id.uuidString.lowercased()
        self.fullName = user.userMetadata["full_name"]?.stringValue
        self.email = user.email
    }
}

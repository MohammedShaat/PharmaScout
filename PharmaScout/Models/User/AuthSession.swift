//
//  AuthSession.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

struct AuthSession {
    let user: AppUser
    let role: UserRole
    let pharmacyStaff: PharmacyStaffMember?
}

enum UserRole {
    case patient
    case pharmacist
}

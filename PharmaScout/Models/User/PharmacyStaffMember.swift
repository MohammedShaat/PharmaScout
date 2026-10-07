//
//  PharmacyStaffMember.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

struct PharmacyStaffMember: Codable, Identifiable, Hashable {
    let id: String
    let userInfo: AppUser
    let pharmacyId: String
    var role: PharmacyStaffRole
    var status: PharmacyStaffStatus
}

enum PharmacyStaffRole: String, Codable, CaseIterable, Hashable {
    case owner = "owner"
    case employee = "employee"
}

enum PharmacyStaffStatus: String, Codable, CaseIterable, Hashable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
}

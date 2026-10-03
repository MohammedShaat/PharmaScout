//
//  PharmacyStaff.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

struct PharmacyStaff: Codable {
    let id: String
    let pharmacyId: String?
    let role: PharmacyStaffRole
    let status: PharmacyStaffStatus
}

enum PharmacyStaffRole: String, Codable {
    case owner = "owner"
    case employee = "employee"
}

enum PharmacyStaffStatus: String, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
}

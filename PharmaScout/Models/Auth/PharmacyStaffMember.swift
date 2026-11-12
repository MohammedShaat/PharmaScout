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
    
    var title: String {
        switch self {
        case .owner: "Owner"
        case .employee: "Employee"
        }
    }
}

enum PharmacyStaffStatus: String, Codable, CaseIterable, Hashable {
    case pending
    case approved
    case rejected
    case suspended
    
    var title: String {
        switch self {
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        case .suspended: "Suspended"
        }
    }
}

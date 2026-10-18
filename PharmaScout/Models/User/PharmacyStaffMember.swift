//
//  PharmacyStaffMember.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

enum AccountState: nonisolated Decodable, Equatable {
    case patient
    case approvedOwner
    case pharmacist(StaffMembership)
    case admin

    private enum CodingKeys: String, CodingKey { case state, membership }
    
    private enum Kind: String, Decodable { case patient, approvedOwner, pharmacist, admin }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .state) {
        case .patient:       self = .patient
        case .approvedOwner: self = .approvedOwner
        case .admin:         self = .admin
        case .pharmacist:
            self = .pharmacist(try container.decode(StaffMembership.self, forKey: .membership))
        }
    }
}

struct StaffMembership: Decodable, Equatable {
    let staffId: String
    let pharmacyId: String
    let role: PharmacyStaffRole
    let staffStatus: PharmacyStaffStatus
    let pharmacyStatus: PharmacyStatus
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


struct PharmacyStaffMember: Codable, Identifiable, Hashable {
    let id: String
    let userInfo: AppUser
    let pharmacyId: String
    var role: PharmacyStaffRole
    var status: PharmacyStaffStatus
}

//
//  UpdatePharmacyStaffMember.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

struct UpdatePharmacyStaffRequest: Codable {
    let staffMembers: [UpdatePharmacyStaffMember]
    
    enum CodingKeys: String, CodingKey {
        case staffMembers = "p_staff_members"
    }
}

struct UpdatePharmacyStaffMember: Codable {
    let id: String
    let role: PharmacyStaffRole
    let status: PharmacyStaffStatus
}


extension UpdatePharmacyStaffMember {
    init(from pharmacyStaffMember: PharmacyStaffMember) {
        self.id = pharmacyStaffMember.id
        self.role = pharmacyStaffMember.role
        self.status = pharmacyStaffMember.status
    }
}

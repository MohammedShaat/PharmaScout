//
//  UpdatePharmacyStaffMember.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

struct ManagePharmacyStaffMemberRequest: Codable {
    let staffId: String
    let action: PharmacyStaffAction
    
    enum CodingKeys: String, CodingKey {
        case staffId = "p_staff_id"
        case action = "p_action"
    }
}

enum PharmacyStaffAction: String, Codable {
    case approve = "approve"
    case reject = "reject"
    case suspend = "suspend"
    case reactivate = "reactivate"
    case delete = "delete"
}

//
//  AuthSession.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

struct AuthSession {
    let user: AppUser
    let accountState: AccountState
}

enum AccountState: nonisolated Decodable {
    case patient
    case pharmacist(StaffMembership)
    case admin
    case ownerApplicant(OwnerApplicationSummary)

    enum CodingKeys: String, CodingKey {
        case state, membership, application
    }
    
    enum Kind: String, Decodable {
        case patient = "patient"
        case ownerApplicant = "owner_applicant"
        case pharmacist = "pharmacist"
        case admin = "admin"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .state) {
        case .admin:
            self = .admin
            
        case .pharmacist:
            self = .pharmacist(try container.decode(StaffMembership.self, forKey: .membership))
            
        case .ownerApplicant:
            self = .ownerApplicant(try container.decode(OwnerApplicationSummary.self, forKey: .application))
            
        case .patient:
            self = .patient
        }
    }
}

struct StaffMembership: Decodable, Equatable {
    let staffId: String
    let pharmacyId: String
    let role: PharmacyStaffRole
    let staffStatus: PharmacyStaffStatus
    let pharmacyStatus: PharmacyStatus
    let pharmacyRejectionReason: String?
    let staffRejectionReason: String?
    
    var isPharmacyApproved: Bool { pharmacyStatus == .approved }
    var isStaffApproved: Bool { staffStatus == .approved }
    var isOwner: Bool { role == .owner }
}

struct OwnerApplicationSummary: Codable {
    let id: String
    let status: OwnerApplicationStatus
}

//enum UserRole {
//    case patient
//    case pharmacist
//    case admin
//}

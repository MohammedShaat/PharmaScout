//
//  ReviewPharmacyRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

struct ReviewPharmacyRequest: Codable {
    let pharmacyId: String
    let approve: Bool
    let rejectionReason: String?
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case approve = "p_approve"
        case rejectionReason = "p_rejection_reason"
    }
}

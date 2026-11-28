//
//  ReviewOwnerApplicationRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import Foundation

struct ReviewOwnerApplicationRequest: Codable {
    let applicationId: String
    let approve: Bool
    
    enum CodingKeys: String, CodingKey {
        case applicationId = "p_application_id"
        case approve = "p_approve"
    }
}

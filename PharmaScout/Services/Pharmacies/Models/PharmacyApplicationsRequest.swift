//
//  PharmacyApplicationsRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

struct PharmacyApplicationsRequest: Codable {
    let limit: Int
    let offset: Int
    var filter: PharmacyApplicationFilter = .all
    
    enum CodingKeys: String, CodingKey {
        case limit = "p_limit"
        case offset = "p_offset"
        case filter = "p_filter"
    }
}

//
//  OwnerApplicationsRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

struct OwnerApplicationsRequest: Codable {
    let limit: Int
    let offset: Int
    var filter: OwnerApplicationFilter = .all
    
    enum CodingKeys: String, CodingKey {
        case limit = "p_limit"
        case offset = "p_offset"
        case filter = "p_filter"
    }
}


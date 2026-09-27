//
//  GetSearchesParams.swift
//  PharmaScout
//
//  Created by Mohammed on 9/28/26.
//

import Foundation

struct GetSearchesParams: Codable {
    let limit: Int
    let offset: Int
    var filter: SearchFilter = .all
    
    enum CodingKeys: String, CodingKey {
        case limit = "p_limit"
        case offset = "p_offset"
        case filter = "p_filter"
    }
}

enum SearchFilter: String, Codable {
    case all
    case pending
    case nonPending = "non_pending"
}

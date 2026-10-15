//
//  ContinueSearchRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation

struct ContinueSearchRequest: Codable {
    let searchId: String
    let radiusMeters: Double
    
    enum CodingKeys: String, CodingKey {
        case searchId = "p_search_id"
        case radiusMeters = "p_radius_meters"
    }
}

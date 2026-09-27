//
//  SearchDrugDetailsParams.swift
//  PharmaScout
//
//  Created by Mohammed on 9/28/26.
//

import Foundation

struct SearchDrugDetailsParams: Codable {
    let latitude: Double
    let longitude: Double
    let searchId: String
    
    enum CodingKeys: String, CodingKey {
        case latitude = "p_latitude"
        case longitude = "p_longitude"
        case searchId = "p_search_id"
    }
}

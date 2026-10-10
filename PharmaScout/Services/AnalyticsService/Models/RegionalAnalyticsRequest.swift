//
//  RegionalAnalyticsRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

struct RegionalAnalyticsRequest: Codable {
    let pharmacyId: String
    let days: Int
    let limit: Int

    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case days = "p_days"
        case limit = "p_limit"
    }
}

//
//  GetInquiriesParams.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

struct GetInquiriesParams: Codable {
    let pharmacyId: String
    let limit: Int
    let offset: Int
    var filter: InquiryFilter = .all
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case limit = "p_limit"
        case offset = "p_offset"
        case filter = "p_status_filter"
    }
}

enum InquiryFilter: String, Codable {
    case all
    case pending
    case answered
    case expired
}

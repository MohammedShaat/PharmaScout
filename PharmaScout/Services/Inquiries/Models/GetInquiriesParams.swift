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
    var searchText: String = ""
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case limit = "p_limit"
        case offset = "p_offset"
        case filter = "p_status_filter"
        case searchText = "p_search_text"
    }
}

enum InquiryFilter: String, Codable, CaseIterable, Identifiable {
    case all
    case pending
    case answered
    case expired
    
    var id: String  { rawValue }
    
    var title: String {
        switch self {
        case .all:
            "All"
        case .pending:
            "Pending"
        case .answered:
            "Answered"
        case .expired:
            "Expired"
        }
    }
}

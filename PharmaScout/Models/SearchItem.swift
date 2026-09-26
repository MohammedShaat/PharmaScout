//
//  SearchItem.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import Foundation

struct SearchItem: Codable, Identifiable {
    let id: String
    let searchId: String
    let drugFormulationId: String
    let status: SearchItemStatus
    let fulfilledPharmacyInquiryId: String
}

enum SearchItemStatus: String, Codable {
    case pending = "pending"
    case fulfilled = "fulfilled"
    case unfulfilled = "unfulfilled"
}

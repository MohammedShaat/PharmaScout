//
//  Search.swift
//  PharmaScout
//
//  Created by Mohammed on 9/21/26.
//

import Foundation

struct Search: Codable, Identifiable, Hashable {
    let id: String
    let fulfilmentMode: FulfilmentMode
    let acceptSubstitute: Bool
    let drugsCount: Int
    let fulfilledDrugsCount: Int
    let status: SearchStatus
    let drugs: [SearchDrug]
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, fulfilmentMode, acceptSubstitute, drugsCount, fulfilledDrugsCount, status, createdAt
        case drugs = "items"
    }
}

struct SearchDrug: Codable, Identifiable, Hashable {
    let id: String
    let genericName: String
    let strength: String
}


enum FulfilmentMode: String, CaseIterable, Codable, Identifiable {
    case singlePharmacy = "single_pharmacy"
    case multiPharmacy = "multi_pharmacy"
    
    var id: Self { self }
}

enum SearchStatus: String, Codable {
    case pending = "pending"
    case partiallyFulfilled = "partially_fulfilled"
    case fulfilled = "fulfilled"
    case unfulfilled = "unfulfilled"
}

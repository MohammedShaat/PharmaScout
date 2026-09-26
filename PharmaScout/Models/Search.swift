//
//  Search.swift
//  PharmaScout
//
//  Created by Mohammed on 9/21/26.
//

import Foundation

struct Search: Codable, Identifiable {
    let id: String
    let fulfilmentMode: FulfilmentMode
    let acceptSubstitute: Bool
    let drugsCount: Int
    let fulfilledDrugsCount: Int
    let status: SearchStatus
    let items: [SearchItem]
    let createdAt: Date
}

struct SearchItem: Codable, Identifiable {
    let id: String
    let genericName: String
    let strength: String
}



enum SearchItemStatus: String, Codable {
    case pending = "pending"
    case fulfilled = "fulfilled"
    case unfulfilled = "unfulfilled"
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

//
//  Search.swift
//  PharmaScout
//
//  Created by Mohammed on 9/21/26.
//

import Foundation

struct Search: Codable, Identifiable {
    let id: String
    let userId: String
    let latitude: Double
    let longitude: Double
    let fulfilmentMode: FulfilmentMode
    let acceptSubstitute: Bool
    let drugsCount: Int
    let fulfilledDrugsCount: Int
    let status: SearchStatus
    let createdAt: Date
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
    case expired = "expired"
}

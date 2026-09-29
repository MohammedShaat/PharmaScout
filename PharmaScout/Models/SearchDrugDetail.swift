//
//  SearchDrugDetail.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import Foundation

struct SearchDrugDetail: Codable, Identifiable {
    let id: String
    let genericName: String
    let drugFormulation: DrugFormulation
    let status: SearchDrugStatus
    let response: SearchDrugResponse?
}

struct SearchDrugResponse: Codable {
    let id: String
    let pharmacy: Pharmacy
    let pharmacyResponse: PharmacyResponse
    let substituteGenericName: String?
    let substituteDrugFormulation: DrugFormulation?
}


enum SearchDrugStatus: String, Codable {
    case pending = "pending"
    case fulfilled = "fulfilled"
    case unfulfilled = "unfulfilled"
}

enum PharmacyResponse: String, Codable {
    case available = "available"
    case unavailable = "unavailable"
    case substitute = "substitute"
}

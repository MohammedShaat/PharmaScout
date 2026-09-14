//
//  SearchRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct SearchRequest: Codable {
    let latitude: Double
    let longitude: Double
    let fulfilmentMode: FulfilmentMode
    let acceptSubstitute: Bool
    let items: [SearchItemRequest]
    let pharmacies: [NearbyPharmacy]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "p_latitude"
        case longitude = "p_longitude"
        case fulfilmentMode = "p_fulfilment_mode"
        case acceptSubstitute = "p_accept_substitute"
        case items = "p_items"
        case pharmacies = "p_pharmacies"
    }
}

struct SearchItemRequest: Codable {
    let drugFormulationId: String
    let quantity: Int
    
    init(from selectedDrug: SelectedDrug) {
        self.drugFormulationId = selectedDrug.formulation.id
        self.quantity = selectedDrug.quanity
    }
}

//
//  GetPharmacyDetailsParams.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import Foundation

struct GetPharmacyDetailsParams: Codable {
    let pharmacyId: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case latitude = "p_latitude"
        case longitude = "p_longitude"
    }
}

//
//  CreatePharmacyRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

struct CreatePharmacyRequest: Codable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let timezone: String
    let hours: [WorkingHour]
    let contacts: [PharmacyContact]
    
    enum CodingKeys: String, CodingKey {
        case name = "p_name"
        case address = "p_address"
        case latitude = "p_latitude"
        case longitude = "p_longitude"
        case timezone = "p_timezone"
        case hours = "p_hours"
        case contacts = "p_contacts"
    }
}

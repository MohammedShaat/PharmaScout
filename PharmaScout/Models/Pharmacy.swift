//
//  Pharmacy.swift
//  PharmaScout
//
//  Created by Mohammed on 9/22/26.
//

import Foundation

struct Pharmacy: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let address: String
    let timezone: String
    let distanceMeters: Double
    let isOpen: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, address, timezone, isOpen
        case distanceMeters = "distance"
    }
    
    var coordinate: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
}

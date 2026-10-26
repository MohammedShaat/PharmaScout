//
//  FindNearbyPharmaciesParams.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//


import Foundation

struct FindNearbyPharmaciesRequest: Codable {
    let latitude: Double
    let longitude: Double
    let radiusMeters: Double
    let limit: Int
    let offset: Int
    var onlyOpen: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case latitude = "p_latitude"
        case longitude = "p_longitude"
        case radiusMeters = "p_radius_meters"
        case limit = "p_limit"
        case offset = "p_offset"
        case onlyOpen = "p_only_open"
    }
}

//
//  NearbyPharmacy.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct NearbyPharmacy: Codable {
    let id: String
    let distanceMeters: Double

    enum CodingKeys: String, CodingKey {
        case id
        case distanceMeters = "distance"
    }
}

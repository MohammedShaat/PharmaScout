//
//  NearbyPharmacy.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct NearbyPharmacy: Codable {
    let id: String
    let latitude: Double
    let longitude: Double
    let distanceMeters: Double
}

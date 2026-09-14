//
//  PharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

protocol PharmacyService {
    func findNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy]
}

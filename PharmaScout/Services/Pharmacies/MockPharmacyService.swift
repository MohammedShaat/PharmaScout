//
//  MockPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct MockPharmacyService: PharmacyService {
    func findNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
        return NearbyPharmacy.samples
    }
}

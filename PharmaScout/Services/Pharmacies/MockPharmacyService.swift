//
//  MockPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct MockPharmacyService: PharmacyService {
    func getNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double) async throws -> [NearbyPharmacy] {
        return NearbyPharmacy.samples
            .filter {
                $0.distanceMeters <= radiusMeters
            }
    }
}

//
//  MockPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct MockPharmacyService: PharmacyService {
    func findOpenNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
        return NearbyPharmacy.samples
    }
    
    func findNearbyPharmacies(params: FindNearbyPharmaciesParams) async throws -> [Pharmacy] {
        try? await Task.sleep(for: .seconds(2))
        
        let nearbyPharmacies = Pharmacy.samples
            .filter {
                $0.distanceMeters <= params.radiusMeters
            }
            .sorted { $0.distanceMeters < $1.distanceMeters }
            .dropFirst(params.offset)
            .prefix(params.limit)
        
        return Array(nearbyPharmacies)
    }
}

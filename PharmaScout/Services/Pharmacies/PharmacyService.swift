//
//  PharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

protocol PharmacyService {
    func getNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double) async throws -> [NearbyPharmacy]
}

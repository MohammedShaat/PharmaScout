//
//  PharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

protocol PharmacyService {
    func findOpenNearbyPharmacies(coordinate: Coordinate, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy]
    
    func findNearbyPharmacies(params: FindNearbyPharmaciesParams) async throws -> [Pharmacy]
    
    func getContactInfo(for pharmacyId: String) async throws -> [PharmacyContact]
    
    func getWorkingHours(for pharmacyId: String) async throws -> [WorkingHour]
}

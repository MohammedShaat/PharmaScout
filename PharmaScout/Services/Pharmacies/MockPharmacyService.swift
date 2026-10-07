//
//  MockPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct MockPharmacyService: PharmacyService {
    func findOpenNearbyPharmacies(coordinate: Coordinate, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
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
    
    func getContactInfo(for pharmacyId: String) async throws -> [PharmacyContact] {
        try? await Task.sleep(for: .seconds(2))
        
        return PharmacyContact.samples
            .filter {
                $0.pharmacyId == pharmacyId
            }
    }
    
    func getWorkingHours(for pharmacyId: String) async throws -> [WorkingHour] {
        try? await Task.sleep(for: .seconds(2))
       
        return []
    }
    
    func getPharmacy(_ params: GetPharmacyDetailsParams) async throws -> Pharmacy {
        try? await Task.sleep(for: .seconds(2))
        
        return Pharmacy.samples
            .first { $0.id == params.pharmacyId }!
    }
    
    func getStaff(for pharmacyId: String) async throws -> [PharmacyStaffMember] {
        try? await Task.sleep(for: .seconds(2))
        
        return PharmacyStaffMember.samples
            .filter { $0.pharmacyId == pharmacyId }
    }
    
    func updatePharmacy(for pharmacyId: String, request: UpdatePharmacyRequest) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func createOrUpdateContacts(contacts: [PharmacyContact]) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func deleteContacts(ids: [String]) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func createOrUpdateWokringHours(workingHours: [WorkingHour]) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func deleteWokringHours(ids: [String]) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func updateStaffMembers(request: UpdatePharmacyStaffRequest) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func deleteStaffMembers(ids: [String]) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
}

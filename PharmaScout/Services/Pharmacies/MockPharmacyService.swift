//
//  MockPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation

struct MockPharmacyService: PharmacyService {
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
    
    func createOrUpdateWokringHours(_ request: UpdateOrCreatePharmacyHoursRequest) async throws {
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
    
    func getActiveJoinCode(for pharmacyId: String) async throws -> InvitaionCode? {
        try? await Task.sleep(for: .seconds(2))
        
        let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return InvitaionCode(code: "A7K2M9", expiresAt: expirationDate)
    }
    
    func generateJoinCode(for pharmacyId: String) async throws -> InvitaionCode {
        try? await Task.sleep(for: .seconds(2))
        
        return .sample
    }
    
    func joinPharmacy(code: String) async throws -> String {
        try? await Task.sleep(for: .seconds(2))
        
        return Pharmacy.samples[0].id
    }
    
    func createPharmacy(_ request: CreatePharmacyRequest) async throws -> String {
        try? await Task.sleep(for: .seconds(2))
        
        return UUID().uuidString
    }
    
    func getPharmacyApplications(_ request: PharmacyApplicationsRequest) async throws -> [PharmacyApplication] {
        try? await Task.sleep(for: .seconds(2))
        
        let filteredPharmacyApplications = PharmacyApplication.samples
            .filter { request.filter == .all || $0.status.rawValue == request.filter.rawValue  }
            .dropFirst(request.offset)
            .prefix(request.limit)
        
        return Array(filteredPharmacyApplications)
    }
    
    func getPharmacyApplication(for pharmacyId: String) async throws -> PharmacyApplication {
        try? await Task.sleep(for: .seconds(2))
        
        return .samples.first { $0.id == pharmacyId }!
    }
    
    func reviewPharmacy(_ request: ReviewPharmacyRequest) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
}

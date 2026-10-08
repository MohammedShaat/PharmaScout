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
    
    func getPharmacy(_ params: GetPharmacyDetailsParams) async throws -> Pharmacy
    
    func getStaff(for pharmacyId: String) async throws -> [PharmacyStaffMember]
    
    func updatePharmacy(for pharmacyId: String, request: UpdatePharmacyRequest) async throws
    
    func createOrUpdateContacts(contacts: [PharmacyContact]) async throws
    
    func deleteContacts(ids: [String]) async throws
    
    func createOrUpdateWokringHours(workingHours: [WorkingHour]) async throws
    
    func deleteWokringHours(ids: [String]) async throws
    
    func updateStaffMembers(request: UpdatePharmacyStaffRequest) async throws
    
    func deleteStaffMembers(ids: [String]) async throws
    
    func getActiveJoinCode(for pharmacyId: String) async throws -> JoinCode?
    
    func generateJoinCode(for pharmacyId: String) async throws -> JoinCode
    
    func joinPharmacy(code: String) async throws -> String
}

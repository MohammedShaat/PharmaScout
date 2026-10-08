//
//  DefaultPharmacyService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/15/26.
//

import Foundation
import Supabase

struct DefaultPharmacyService: PharmacyService {
    private let supabase = SupabaseManager.shared.client
    
    func findOpenNearbyPharmacies(coordinate: Coordinate, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
        
        let findPharmaciesWithinDistanceFunc = SupabaseManager.Database.Functions.findPharmaciesWithinDistance.self
        let params = findPharmaciesWithinDistanceFunc.Params
        
        do {
            let nearbyPharmacies: [NearbyPharmacy] = try await supabase
                .rpc(
                    findPharmaciesWithinDistanceFunc.name,
                    params: [
                        params.latitude: coordinate.latitude,
                        params.longitude: coordinate.longitude,
                        params.radiusMeters: radiusMeters
                    ]
                )
                .limit(count)
                .execute()
                .value
            
            return nearbyPharmacies
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func findNearbyPharmacies(params: FindNearbyPharmaciesParams) async throws -> [Pharmacy] {
        
        let findNearbyPharmaciesFunc = SupabaseManager.Database.Functions.findNearbyPharmacies.self
        do {
            let nearbyPharmacies: [Pharmacy] = try await supabase
                .rpc(
                    findNearbyPharmaciesFunc.name,
                    params: params
                )
                .execute()
                .value
            
            return nearbyPharmacies
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getContactInfo(for pharmacyId: String) async throws -> [PharmacyContact] {
        
        let pharmacyContactTable = SupabaseManager.Database.Table.PharmacyContact.self
        let columns = pharmacyContactTable.Column.self
        do {
            let contacts: [PharmacyContact] = try await supabase
                .from(pharmacyContactTable.name)
                .select("\(columns.id), \(columns.pharmacyId), \(columns.title), \(columns.type), \(columns.value)")
                .eq(columns.pharmacyId, value: pharmacyId)
                .execute()
                .value
            
            return contacts
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getWorkingHours(for pharmacyId: String) async throws -> [WorkingHour] {
        let pharmacyHoursTable = SupabaseManager.Database.Table.PharmacyHours.self
        let columns = pharmacyHoursTable.Column.self

        do {
            let hours: [WorkingHour] = try await supabase
                .from(pharmacyHoursTable.name)
                .select("\(columns.id), \(columns.pharmacyId), \(columns.day), \(columns.opensAt), \(columns.closesAt)")
                .eq(columns.pharmacyId, value: pharmacyId)
                .execute()
                .value
            
            return hours
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getPharmacy(_ params: GetPharmacyDetailsParams) async throws -> Pharmacy {
        let getPharmacyDetailsFunc = SupabaseManager.Database.Functions.getPharmacyDetails.self
        
        do {
            let pharmacy: Pharmacy = try await supabase
                .rpc(getPharmacyDetailsFunc.name, params: params)
                .single()
                .execute()
                .value
            
            return pharmacy
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getStaff(for pharmacyId: String) async throws -> [PharmacyStaffMember] {
        let getPharmacyStaffFunc = SupabaseManager.Database.Functions.getPharmacyStaff.self
        let params = getPharmacyStaffFunc.Params.self
        
        do {
            let staff: [PharmacyStaffMember] = try await supabase
                .rpc(
                    getPharmacyStaffFunc.name,
                    params: [params.pharmacyId: pharmacyId]
                )
                .execute()
                .value
            
            return staff
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func updatePharmacy( for pharmacyId: String, request: UpdatePharmacyRequest) async throws {
        let pharmacyTable = SupabaseManager.Database.Table.Pharmacy.self
        let columns = pharmacyTable.Column.self
        
        do {
            try await supabase
                .from(pharmacyTable.name)
                .update(request)
                .equals(columns.id, value: pharmacyId)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func createOrUpdateContacts(contacts: [PharmacyContact]) async throws {
        let pharmacyContactTable = SupabaseManager.Database.Table.PharmacyContact.self
        
        do {
            try await supabase
                .from(pharmacyContactTable.name)
                .upsert(contacts)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func deleteContacts(ids: [String]) async throws {
        let pharmacyContactTable = SupabaseManager.Database.Table.PharmacyContact.self
        let columns = pharmacyContactTable.Column.self
        
        do {
            try await supabase
                .from(pharmacyContactTable.name)
                .delete()
                .in(columns.id, values: ids)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func createOrUpdateWokringHours(workingHours: [WorkingHour]) async throws {
        let pharmacyHoursTable = SupabaseManager.Database.Table.PharmacyHours.self
        
        do {
            try await supabase
                .from(pharmacyHoursTable.name)
                .upsert(workingHours)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func deleteWokringHours(ids: [String]) async throws {
        let pharmacyHoursTable = SupabaseManager.Database.Table.PharmacyHours.self
        let columns = pharmacyHoursTable.Column.self
        
        do {
            try await supabase
                .from(pharmacyHoursTable.name)
                .delete()
                .in(columns.id, values: ids)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func updateStaffMembers(request: UpdatePharmacyStaffRequest) async throws {
        let updatePharmacyStaffFunc = SupabaseManager.Database.Functions.updatePharmacyStaffMembers.self
        do {
            try await supabase
                .rpc(updatePharmacyStaffFunc.name, params: request)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func deleteStaffMembers(ids: [String]) async throws {
        let pharmacyStaffTable = SupabaseManager.Database.Table.PharmacyStaff.self
        let columns = pharmacyStaffTable.Column.self
        
        do {
            try await supabase
                .from(pharmacyStaffTable.name)
                .delete()
                .in(columns.id, values: ids)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getActiveJoinCode(for pharmacyId: String) async throws -> JoinCode? {
        let getActivePharmacyJoinCodeFunc = SupabaseManager.Database.Functions.getActivePharmacyJoinCode.self
        let params = getActivePharmacyJoinCodeFunc.Params.self
        
        do {
            let joinCode: JoinCode? = try await supabase
                .rpc(
                    getActivePharmacyJoinCodeFunc.name,
                    params: [params.pharmacyId: pharmacyId]
                )
                .maybeSingle()
                .execute()
                .value
            
            return joinCode
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func generateJoinCode(for pharmacyId: String) async throws -> JoinCode {
        let generatePharmacyJoinCodeFunc = SupabaseManager.Database.Functions.generatePharmacyJoinCode.self
        let params = generatePharmacyJoinCodeFunc.Params.self
        
        do {
            let joinCode: JoinCode = try await supabase
                .rpc(
                    generatePharmacyJoinCodeFunc.name,
                    params: [params.pharmacyId: pharmacyId]
                )
                .single()
                .execute()
                .value
            
            return joinCode
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func joinPharmacy(code: String) async throws -> String {
        let joinPharmacyFunc = SupabaseManager.Database.Functions.joinPharmacy.self
        let params = joinPharmacyFunc.Params.self
        
        do {
            let pharmacyId: String = try await supabase
                .rpc(
                    joinPharmacyFunc.name,
                    params: [params.code: code]
                )
                .execute()
                .value
            
            return pharmacyId
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

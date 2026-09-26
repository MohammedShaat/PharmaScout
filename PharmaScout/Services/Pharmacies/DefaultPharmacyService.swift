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
}

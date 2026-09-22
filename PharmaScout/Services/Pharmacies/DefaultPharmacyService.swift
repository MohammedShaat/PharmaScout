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
    
    func findOpenNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
        
        let findPharmaciesWithinDistanceFunc = SupabaseManager.Database.Functions.findPharmaciesWithinDistance.self
        let params = findPharmaciesWithinDistanceFunc.Params
        
        do {
            let nearbyPharmacies: [NearbyPharmacy] = try await supabase
                .rpc(
                    findPharmaciesWithinDistanceFunc.name,
                    params: [
                        params.latitude: latitude,
                        params.longitude: longitude,
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
}

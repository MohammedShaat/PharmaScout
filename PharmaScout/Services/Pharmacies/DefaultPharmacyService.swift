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
    
    func findNearbyPharmacies(latitude: Double, longitude: Double, radiusMeters: Double, count: Int) async throws -> [NearbyPharmacy] {
        
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
}

//
//  DefaultAnalyticsService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation
import Supabase

struct DefaultAnalyticsService: AnalyticsService {
    private let supabase = SupabaseManager.shared.client
    
    func getRegionalDemandAnalytics(request: RegionalAnalyticsRequest) async throws -> [DrugDemand] {
        let getRegionalDemandFunc = SupabaseManager.Database.Functions.getRegionalDemandAnalytics.self
        
        do {
            let drugDemands: [DrugDemand] = try await supabase
                .rpc(getRegionalDemandFunc.name, params: request)
                .execute()
                .value
            
            return drugDemands
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

//
//  MockAnalyticsService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

struct MockAnalyticsService: AnalyticsService {
    func getRegionalDemandAnalytics(request: AnalyticsRequest) async throws -> [DrugDemand] {
        try? await Task.sleep(for: .seconds(2))
        
        let subDrugDemands = DrugDemand.samples.prefix(request.limit)
        
        return Array(subDrugDemands)
    }
    
    func getPharmacySearchAnalytics(request: AnalyticsRequest) async throws -> PharmacySearchAnalytics {
        try? await Task.sleep(for: .seconds(2))
        
        let subDrugDemands = DrugDemand.samples.prefix(request.limit)
        
        let totalDrugsRequested = Int.random(in: 30...50)
        let totalDrugsAnswered: Int = .random(in: 20...totalDrugsRequested)
        let totalDrugsAnsweredAvailable: Int = .random(in: 10...totalDrugsAnswered)
        
        return PharmacySearchAnalytics(
            drugDemands: Array(subDrugDemands),
            totalDrugsRequested: totalDrugsRequested,
            totalDrugsAnswered: totalDrugsAnswered,
            totalDrugsAnsweredAvailable: totalDrugsAnsweredAvailable
        )
    }
}

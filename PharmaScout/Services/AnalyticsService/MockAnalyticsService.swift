//
//  MockAnalyticsService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

struct MockAnalyticsService: AnalyticsService {
    func getRegionalDemandAnalytics(request: RegionalAnalyticsRequest) async throws -> [DrugDemand] {
        try? await Task.sleep(for: .seconds(2))
        
        let subDrugDemands = DrugDemand.samples.prefix(request.limit)
        
        return Array(subDrugDemands)
    }
}

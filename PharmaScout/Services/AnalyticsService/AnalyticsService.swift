//
//  AnalyticsService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

protocol AnalyticsService {
    func getRegionalDemandAnalytics(request: RegionalAnalyticsRequest) async throws -> [DrugDemand]
}

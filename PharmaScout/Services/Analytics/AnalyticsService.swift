//
//  AnalyticsService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

protocol AnalyticsService {
    func getRegionalDemandAnalytics(request: AnalyticsRequest) async throws -> [DrugDemand]
    
    func getPharmacySearchAnalytics(request: AnalyticsRequest) async throws -> PharmacySearchAnalytics
}

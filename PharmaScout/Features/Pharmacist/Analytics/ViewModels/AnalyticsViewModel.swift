//
//  AnalyticsViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

@Observable
class AnalyticsViewModel {
    private let authService: AuthService
    private let analyticsService: AnalyticsService
    
    private var pharmacyId: String? {
        authService.authSession?.pharmacyStaff?.pharmacyId
    }
    
    var analyticsType: AnalyticsType = .pharmacySearch
    var period: AnalyticsPeriod = .thirtyDays
    
    private(set) var pharmacySearchAnalytics: PharmacySearchAnalytics?
    private(set) var regionalDrugDemands: [DrugDemand] = []
    
    private(set) var pharmacyAnalyticsLoadingState: LoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    private(set) var regionalAnalyticsLoadingState: LoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(authService: AuthService, analyticsService: AnalyticsService) {
        self.authService = authService
        self.analyticsService = analyticsService
    }

    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadAnalyticsIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadAnalytics()
        }
    }
    
    func refresh() async {
        await loadAnalytics(refresh: true)
    }
    
    func loadAnalytics(refresh: Bool = false) async {
        switch analyticsType {
        case .pharmacySearch:
            await loadPharmacySearchAnalytics(refresh: refresh)
        case .regional:
            await loadRegionalDemandAnalytics(refresh: refresh)
        }
    }
    
    private func loadPharmacySearchAnalytics(refresh: Bool = false) async {
        guard let pharmacyId else {
            pharmacyAnalyticsLoadingState.fail(PharmacyStaffError.notFound)
            print("Failed to load pharmacy search analytics. No pharmacy id")
            return
        }
        
        pharmacyAnalyticsLoadingState.startLoading(refresh: refresh)
        defer { pharmacyAnalyticsLoadingState.stopLoading() }
        
        do {
            let request = AnalyticsRequest(
                pharmacyId: pharmacyId,
                days: period.rawValue,
                limit: pharmacyAnalyticsLoadingState.pagination.pageSize
            )
            pharmacySearchAnalytics = try await analyticsService.getPharmacySearchAnalytics(request: request)
            
        } catch {
            pharmacyAnalyticsLoadingState.fail(error)
            print("Failed to load pharmacy search analytics\n", error)
        }
    }
    
    private func loadRegionalDemandAnalytics(refresh: Bool = false) async {
        guard let pharmacyId else {
            regionalAnalyticsLoadingState.fail(PharmacyStaffError.notFound)
            print("Failed to load regional demand analytics. No pharmacy id")
            return
        }
        
        regionalAnalyticsLoadingState.startLoading(refresh: refresh)
        defer { regionalAnalyticsLoadingState.stopLoading() }
        
        do {
            let request = AnalyticsRequest(
                pharmacyId: pharmacyId,
                days: period.rawValue,
                limit: regionalAnalyticsLoadingState.pagination.pageSize
            )
            regionalDrugDemands = try await analyticsService.getRegionalDemandAnalytics(request: request)
            
        } catch {
            regionalAnalyticsLoadingState.fail(error)
            print("Failed to load regional demand analytics\n", error)
        }
    }
}




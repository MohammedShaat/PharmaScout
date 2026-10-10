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
    
    var period: AnalyticsPeriod = .thirtyDays
    
    private(set) var drugDemands: [DrugDemand] = []
    private(set) var loadingState: LoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
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
            await loadRegionalDemandAnalytics()
        }
    }
    
    func refresh() async {
        await loadRegionalDemandAnalytics(refresh: true)
    }
    
    func loadRegionalDemandAnalytics(refresh: Bool = false) async {
        guard let pharmacyId else {
            loadingState.fail(PharmacyStaffError.notFound)
            print("Failed to load regional demand analytics. No pharmacy id")
            return
        }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let request = RegionalAnalyticsRequest(
                pharmacyId: pharmacyId,
                days: period.rawValue,
                limit: loadingState.pagination.pageSize
            )
            drugDemands = try await analyticsService.getRegionalDemandAnalytics(request: request)
            
        } catch {
            loadingState.fail(error)
            print("Failed to load regional demand analytics\n", error)
        }
    }
}




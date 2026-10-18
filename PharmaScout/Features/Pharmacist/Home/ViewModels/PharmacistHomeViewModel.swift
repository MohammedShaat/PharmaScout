//
//  PharmacistHomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

@Observable
class PharmacistHomeViewModel {
    let staffMembership: StaffMembership
    private let authService: AuthService
    private let inquiryService: InquiryService
    
    var authSession: AuthSession? { authService.authSession }
    var isAuthorized: Bool {
        staffMembership.staffStatus == .approved
    }
    var pharmacyId: String { staffMembership.pharmacyId }
    
    var hasUnreadNotifications: Bool = true
    
    private(set) var latestPendingInquiries: [Inquiry] = []
    private(set) var latestPendingInquiriesLoadingState = LoadingState(pageSize: 3)
    
    private(set) var allTodaysInquiriesCount: Int = 0
    private(set) var answeredTodaysInquiriesCount: Int = 0
    private(set) var todaysInquiriesCountLoadingState = LoadingState()
    
    private(set) var authSessionLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(staffMembership: StaffMembership, authService: AuthService, inquiryService: InquiryService) {
        self.staffMembership = staffMembership
        self.authService = authService
        self.inquiryService = inquiryService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            async let pendingInquiries = loadPendingInquiries()
            async let numberOfTodaysInquiries = getNumberOfTodaysInquiries()
            
            _ = await (pendingInquiries, numberOfTodaysInquiries)
        }
    }
    
    func refresh() async {
        if !isAuthorized {
            await refreshAuthSession()
        } else {
            await refreshData()
        }
    }
    
    private func refreshData() async {
        async let pendingInquiries = loadPendingInquiries()
        async let numberOfTodaysInquiries = getNumberOfTodaysInquiries()
        
        _ = await (pendingInquiries, numberOfTodaysInquiries)
    }
    
    private func refreshAuthSession() async {
        authSessionLoadingState.startLoading(refresh: true)
        defer { authSessionLoadingState.stopLoading() }
        
        do {
            try await authService.refreshAuthSession()
            
        } catch {
            authSessionLoadingState.fail(error)
            print("Failed to refresh auth session\n", error)
        }
    }
    
    private func loadPendingInquiries(refresh: Bool = false) async {
        latestPendingInquiriesLoadingState.startLoading(refresh: refresh)
        defer { latestPendingInquiriesLoadingState.stopLoading() }
        
        do {
            let params = GetInquiriesParams(
                pharmacyId: pharmacyId,
                limit: latestPendingInquiriesLoadingState.pagination.pageSize,
                offset: 0,
                filter: .pending
            )
            latestPendingInquiries = try await inquiryService.getInquiries(params)
            
        } catch {
            latestPendingInquiriesLoadingState.fail(error)
            print("Failed to load pending inquiries\n", error)
        }
    }
    
    private func getNumberOfTodaysInquiries(refresh: Bool = false) async {
        todaysInquiriesCountLoadingState.startLoading(refresh: refresh)
        defer { todaysInquiriesCountLoadingState.stopLoading() }
        
        do {
            async let getAllTodaysInquiries = inquiryService.getNumberOfAllTodaysInquiries(for: pharmacyId)
            async let getAnsweredTodaysInquiries = inquiryService.getNumberOfAnsweredTodaysInquiries(for: pharmacyId)
            
            (allTodaysInquiriesCount, answeredTodaysInquiriesCount) = try await (getAllTodaysInquiries, getAnsweredTodaysInquiries)
            
        } catch {
            todaysInquiriesCountLoadingState.fail(error)
            print("Failed to get number of toay's inquires\n", error)
        }
    }
}

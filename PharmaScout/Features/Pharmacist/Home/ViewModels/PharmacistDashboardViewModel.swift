//
//  PharmacistHomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

@Observable
class PharmacistDashboardViewModel {
    let staffMembership: StaffMembership
    private let inquiryService: InquiryService
    private let authService: AuthService
    
    var user: AppUser? { authService.authSession?.user }
    
    var pharmacyId: String { staffMembership.pharmacyId }
    
    var hasUnreadNotifications: Bool = true
    
    private(set) var latestPendingInquiries: [Inquiry] = []
    private(set) var latestPendingInquiriesLoadingState = LoadingState(pageSize: 3)
    
    private(set) var allTodaysInquiriesCount: Int = 0
    private(set) var answeredTodaysInquiriesCount: Int = 0
    private(set) var todaysInquiriesCountLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(staffMembership: StaffMembership, inquiryService: InquiryService, authService: AuthService) {
        self.staffMembership = staffMembership
        self.inquiryService = inquiryService
        self.authService = authService
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
    
    func refreshData() async {
        async let pendingInquiries = loadPendingInquiries()
        async let numberOfTodaysInquiries = getNumberOfTodaysInquiries()
        
        _ = await (pendingInquiries, numberOfTodaysInquiries)
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

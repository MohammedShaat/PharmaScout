//
//  InquiriesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

@Observable
class InquiriesViewModel {
    private let authService: AuthService
    private let inquiryService: InquiryService
    
    private(set) var inquiries: [Inquiry] = []
    private(set) var loadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(authService: AuthService, inquiryService: InquiryService) {
        self.inquiryService = inquiryService
        self.authService = authService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadInquiriesIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadInquiries()
        }
    }
    
    func refresh() async {
        await loadInquiries(refresh: true)
    }
    
    func loadMore() async {
        await loadInquiries()
    }
    
    private func loadInquiries(refresh: Bool = false) async {
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        guard let pharmacyId = authService.authSession?.pharmacyStaff?.pharmacyId else {
            loadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        do {
            let params = GetInquiriesParams(
                pharmacyId: pharmacyId,
                limit: refresh ? max(inquiries.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                offset: refresh ? 0 : inquiries.count
            )
            let newInquiries = try await inquiryService.getInquiries(params)
            
            if refresh {
                inquiries = newInquiries
            } else {
                inquiries.append(contentsOf: newInquiries)
    
                if newInquiries.isNotEmpty {
                    loadingState.pagination.nextPage()
                }
            }
            
        } catch {
            loadingState.fail(error)
            print("Failed to load inquiries\n", error)
        }
    }
}

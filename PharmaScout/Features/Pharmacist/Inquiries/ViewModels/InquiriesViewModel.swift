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
    var filter: InquiryFilter = .all
    
    var searchText: String = "" {
        didSet { onSearchTextChanged() }
    }
    private(set) var lastSearchText: String = ""
    
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
    
    func onFilterChanged() async {
        loadingState.pagination.reset()
        await loadInquiries(filterHasChanged: true)
    }
    
    func loadInquiries(refresh: Bool = false, filterHasChanged: Bool = false) async {
        guard let pharmacyId = authService.authSession?.pharmacyStaff?.pharmacyId else {
            loadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        var shouldPerform: Bool {
            SearchRequestPolicy.shouldPerform(
                query: searchText,
                lastQuery: lastSearchText,
                allowsEmptyQuery: true,
                hasPreviousPage: loadingState.pagination.hasPreviousPage,
                isRefreshing: loadingState.status == .refreshing
            )
        }
        
        await SearchRequestPolicy.perform(
            shouldPerform: shouldPerform || filterHasChanged,
            hasPreviousPage: loadingState.pagination.hasPreviousPage,
            isRefreshing: refresh,
            stopLoading: {
                loadingState.stopLoading()
            },
            startLoading: {
                loadingState.startLoading(refresh: refresh)
            },
            advancePage: {
                loadingState.pagination.nextPage()
            },
            handleError: { error in
                loadingState.fail(error)
                print("Failed to load inquiries\n", error)
            },
            query: searchText,
            updateLastQuery: {
                lastSearchText = searchText
            }) {
                let params = GetInquiriesParams(
                    pharmacyId: pharmacyId,
                    limit: refresh ? max(inquiries.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                    offset: refresh || !loadingState.pagination.hasPreviousPage ? 0 : inquiries.count,
                    filter: filter,
                    searchText: searchText
                )
                
                return try await inquiryService.getInquiries(params)
                
            } onSuccess: { newInquiries in
                if refresh {
                    inquiries = newInquiries
                    
                } else {
                    if loadingState.pagination.hasPreviousPage {
                        inquiries.append(contentsOf: newInquiries)
                    } else {
                        inquiries = newInquiries
                    }
                }
            }
    }
    
    private func onSearchTextChanged() {
        loadingState.pagination.reset()
    }
}

//
//  InquiriesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

@Observable
class InquiriesViewModel {
    private let staffMembership: StaffMembership
    private let inquiryService: InquiryService
    
    private(set) var inquiries: [Inquiry] = []
    var filter: InquiryFilter = .all
    
    var searchText: String = ""
    private(set) var lastSearchText: String?
    
    private(set) var loadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private var hasLoadedOnce: Bool = false
    
    init(staffMembership: StaffMembership, inquiryService: InquiryService) {
        self.inquiryService = inquiryService
        self.staffMembership = staffMembership
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
    
    func onSearchTextChanged() async {
        loadingState.pagination.reset()
        await loadInquiries()
    }
    
    func listenToChanges() async {
        do {
            try await changesListener(
                needsCatchup: hasLoadedOnce,
                realtimeStream: {
                    try await inquiryService.subscribeToPharmacyInquiriesChanges(
                        pharmacyId: staffMembership.pharmacyId
                    )
                },
                trigger: refresh
            )
        } catch {
            print("Failed to subscribe to inquiry changes\n", error)
        }
    }
    
    private func loadInquiries(refresh: Bool = false, filterHasChanged: Bool = false) async {
        var shouldPerform: Bool {
            SearchRequestPolicy.shouldPerform(
                query: searchText,
                lastQuery: lastSearchText,
                allowsEmptyQuery: true,
                hasPreviousPage: loadingState.pagination.hasPreviousPage,
                isRefreshing: refresh
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
                    pharmacyId: staffMembership.pharmacyId,
                    limit: refresh ? max(inquiries.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                    offset: refresh || !loadingState.pagination.hasPreviousPage ? 0 : inquiries.count,
                    filter: filter,
                    searchText: searchText
                )
                
                return try await inquiryService.getInquiries(params)
                
            } onSuccess: { newInquiries in
                hasLoadedOnce = true
                
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
}

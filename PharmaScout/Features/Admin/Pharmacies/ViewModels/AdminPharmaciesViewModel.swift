//
//  AdminPharmaciesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

@Observable
class AdminPharmaciesViewModel {
    private let pharmacyService: PharmacyService
    
    private(set) var pharmacyApplications: [PharmacyApplication] = []
    var filter: PharmacyApplicationFilter = .pending
    
    private(set) var loadingState: LoadingState = .init(pageSize: AppConstants.Network.pageSize)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService) {
        self.pharmacyService = pharmacyService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadPharmacyApplicationsaIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadPharmacyApplications()
        }
    }
    
    func refresh() async {
        await loadPharmacyApplications(refresh: true)
    }
    
    func loadMore() async {
        await loadPharmacyApplications()
    }
    
    func onFilterChanged() async {
        loadingState.pagination.reset()
        await loadPharmacyApplications()
    }
    
    private func loadPharmacyApplications(refresh refreshing: Bool = false) async {
        loadingState.startLoading(refresh: refreshing)
        defer { loadingState.stopLoading() }
        
        do {
            let request = PharmacyApplicationsRequest(
                limit: refreshing ? max(pharmacyApplications.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                offset: refreshing || !loadingState.pagination.hasPreviousPage ? 0 : pharmacyApplications.count,
                filter: filter
            )
            let newPharmacyApplications = try await pharmacyService.getPharmacyApplications(request)
            
            if refreshing {
                pharmacyApplications = newPharmacyApplications
            } else {
                if loadingState.pagination.hasPreviousPage {
                    pharmacyApplications.append(contentsOf: newPharmacyApplications)
                } else {
                    pharmacyApplications = newPharmacyApplications
                }
                
                if newPharmacyApplications.isNotEmpty {
                    loadingState.pagination.nextPage()
                }
            }
            
        } catch {
            loadingState.fail(error)
            print("Failed to get pharmacy applications\n", error)
        }
    }
}

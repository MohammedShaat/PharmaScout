//
//  OwnerApplicationsViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class OwnerApplicationsViewModel {
    private let ownerApplicationService: OwnerApplicationService
    
    private(set) var applications: [OwnerApplication] = []
    var filter: OwnerApplicationFilter = .pending
    
    private(set) var loadingState: LoadingState = .init(pageSize: AppConstants.Network.pageSize)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService) {
        self.ownerApplicationService = ownerApplicationService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadApplicationsIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadApplications()
        }
    }
    
    func refresh() async {
        await loadApplications(refresh: true)
    }
    
    func loadMore() async {
        await loadApplications()
    }
    
    func onFilterChanged() async {
        loadingState.pagination.reset()
        await loadApplications()
    }
    
    private func loadApplications(refresh refreshing: Bool = false) async {
        loadingState.startLoading(refresh: refreshing)
        defer { loadingState.stopLoading() }
        
        do {
            let request = OwnerApplicationsRequest(
                limit: refreshing ? max(applications.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                offset: refreshing || !loadingState.pagination.hasPreviousPage ? 0 : applications.count,
                filter: filter
            )
            let newApplications = try await ownerApplicationService.getOwnerApplications(request)
            
            if refreshing {
                applications = newApplications
            } else {
                if loadingState.pagination.hasPreviousPage {
                    applications.append(contentsOf: newApplications)
                } else {
                    applications = newApplications
                }
                
                if newApplications.isNotEmpty {
                    loadingState.pagination.nextPage()
                }
            }
            
        } catch {
            loadingState.fail(error)
            print("Failed to get owner applications\n", error)
        }
    }
}

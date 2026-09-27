//
//  RecentSearchesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import Foundation

@Observable
class RecentSearchesViewModel {
    private let searchRequestService: SearchRequestService
    
    private(set) var searches: [Search] = []
    private(set) var loadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(searchRequestService: SearchRequestService) {
        self.searchRequestService = searchRequestService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadSearchesIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadSearches()
        }
    }
    
    func loadMore() async {
        await loadSearches()
    }
    
    func refresh() async {
        await loadSearches(refresh: true)
    }
    
    private func loadSearches(refresh: Bool = false) async {
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = GetSearchesParams(
                limit: refresh ? max(searches.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
                offset: refresh ? 0 : searches.count
            )
            let newSearchs = try await searchRequestService.getSearches(params)
            
            if refresh {
                searches = newSearchs
            } else {
                searches.append(contentsOf: newSearchs)
            }
            
            if newSearchs.isNotEmpty {
                loadingState.pagination.nextPage()
            }
            
        } catch {
            loadingState.fail(error)
            print("Failed to load searches\n", error)
        }
    }
}

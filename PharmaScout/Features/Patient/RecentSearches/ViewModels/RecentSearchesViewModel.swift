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
    
    init(searchRequestService: SearchRequestService) {
        self.searchRequestService = searchRequestService
    }
    
    func loadSearches(refresh: Bool = false) async {
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let newSearchs = try await searchRequestService.getSearches(
                limit: refresh ? searches.count : loadingState.pagination.pageSize,
                offset: refresh ? 0 : searches.count
            )
            
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
    
    func loadMore() async {
        await loadSearches()
    }
    
    func refresh() async {
        await loadSearches(refresh: true)
    }
}

//
//  RecentSearchesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import Foundation

@Observable
class RecentSearchesViewModel {
    private let authService: AuthService
    private let searchRequestService: SearchRequestService
    
    private(set) var loadingState = LoadingState()
    
    init(authService: AuthService, searchRequestService: SearchRequestService) {
        self.authService = authService
        self.searchRequestService = searchRequestService
    }
    
    func loadRecentSearches() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            let userId = try await authService.getUser().id
            let newSearchs = try await searchRequestService.getRecentSearches(userId: userId)
            print(newSearchs)
            
        } catch {
            loadingState.fail(error)
            print("Failed to load recent searches\n", error)
        }
    }
}

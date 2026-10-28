//
//  MockSearchRequestService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

struct MockSearchRequestService: SearchRequestService {
    func createSearchRequest(request: SearchRequest) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func getNumberOfActiveSearchs(userId: String) async throws -> Int {
        try? await Task.sleep(for: .seconds(2))
        
        return 3
    }
    
    func getSearches(_ params: GetSearchesParams) async throws -> [Search] {
        try? await Task.sleep(for: .seconds(2))
        
        let filteredSearches = Search.samples
            .filter { search in
                params.filter == .all ||
                (params.filter == .nonPending && search.status != .pending) ||
                (params.filter.rawValue == search.status.rawValue)
            }
            .sorted { $0.createdAt < $1.createdAt }
            .dropFirst(params.offset)
            .prefix(params.limit)
        
        return Array(filteredSearches)
    }
    
    func getSearch(for searchId: String) async throws -> Search {
        try? await Task.sleep(for: .seconds(2))

        return Search.samples.first { $0.id == searchId }!
    }
    
    func getSearchDrugDetails(_ params: SearchDrugDetailsParams) async throws -> [SearchDrugDetail] {
        try? await Task.sleep(for: .seconds(2))
        
        guard let drugIds = Search.samples.first(where: { $0.id == params.searchId })?.drugs.map(\.id) else {
            return []
        }
        
        let filteredSarchDrugDetails = SearchDrugDetail.samples
            .filter { drugIds.contains($0.id) }
        
        return Array(filteredSarchDrugDetails)
    }
    
    func continueSearch(request: ContinueSearchRequest) async throws -> Int {
        try? await Task.sleep(for: .seconds(2))
        
        return 2
    }
    
    func subscribeToUserSearchsChanges(userId: String) async throws -> AsyncStream<Void> {
        .makeStream().stream
    }
    
    func subscribeToSearchChanges(searchId: String) async throws -> AsyncStream<Void> {
        .makeStream().stream
    }
}

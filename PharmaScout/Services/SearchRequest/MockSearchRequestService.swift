//
//  MockSearchRequestService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

struct MockSearchRequestService: SearchRequestService {
    func createSearchRequest(request: SearchRequest) async throws {}
    
    func getNumberOfActiveSearchs(userId: String) async throws -> Int {
        3
    }
    
    func getSearches(limit: Int, offset: Int) async throws -> [Search] {
        try? await Task.sleep(for: .seconds(2))
        
        let slicedSearches = Search.samples
            .filter { $0.status != .pending }
            .sorted { $0.createdAt < $1.createdAt }
            .dropFirst(offset)
            .prefix(limit)
        
        return Array(slicedSearches)
    }
}

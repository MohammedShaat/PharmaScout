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
    
    func getRecentSearches(userId: String) async throws -> [SearchItem] {
        []
    }
}

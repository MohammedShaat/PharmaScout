//
//  SearchRequestService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

protocol SearchRequestService {
    func createSearchRequest(request: SearchRequest) async throws
    
    func getNumberOfActiveSearchs(userId: String) async throws -> Int
    
    func getRecentSearches(userId: String) async throws -> [SearchItem]
}

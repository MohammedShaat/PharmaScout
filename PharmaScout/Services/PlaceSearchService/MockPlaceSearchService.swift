//
//  MockPlaceSearchService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

struct MockPlaceSearchService: PlaceSearchService {
    let suggestionsStream: AsyncStream<Result<[PlaceSuggestion], Error>>
    private let suggestionContinuation: AsyncStream<Result<[PlaceSuggestion], Error>>.Continuation
    
    init() {
        (suggestionsStream, suggestionContinuation) = AsyncStream.makeStream()
    }
    
    func updateQuery(_ query: String) {
        suggestionContinuation.yield(.success(PlaceSuggestion.samples))
    }

    func coordinate(for placeSuggestion: PlaceSuggestion) async throws -> Coordinate? {
        return nil
    }
    
    func updateRegion(center: Coordinate, latitudeDelta: Double, longitudeDelta: Double) {
        
    }
}

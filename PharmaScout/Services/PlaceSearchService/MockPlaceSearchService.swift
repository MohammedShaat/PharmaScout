//
//  MockPlaceSearchService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

struct MockPlaceSearchService: PlaceSearchService {
    let suggestionsStream: AsyncStream<Result<[PlaceSuggestion], Error>> = .makeStream().stream
    
    func updateQuery(_ query: String) {
        
    }

    func coordinate(for placeSuggestion: PlaceSuggestion) async throws -> Coordinate? {
        return nil
    }
    
    func updateRegion(center: Coordinate, latitudeDelta: Double, longitudeDelta: Double) {
        
    }
}

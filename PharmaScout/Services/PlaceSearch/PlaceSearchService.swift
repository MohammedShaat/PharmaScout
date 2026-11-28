//
//  PlaceSearchService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

protocol PlaceSearchService {
    var suggestionsStream: AsyncStream<Result<[PlaceSuggestion], Error>> { get }
    
    func updateQuery(_ query: String)
   
    func coordinate(for placeSuggestion: PlaceSuggestion) async throws -> Coordinate?
    
    func updateRegion(center: Coordinate, latitudeDelta: Double, longitudeDelta: Double)
}

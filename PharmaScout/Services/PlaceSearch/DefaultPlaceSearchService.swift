//
//  DefaultPlaceSearchService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation
import MapKit

class DefaultPlaceSearchService: NSObject, PlaceSearchService {
    private let completer = MKLocalSearchCompleter()
    
    private(set) var completionsById: [PlaceSuggestion.ID: MKLocalSearchCompletion] = [:]
    
    let suggestionsStream: AsyncStream<Result<[PlaceSuggestion], Error>>
    private let suggestionContinuation: AsyncStream<Result<[PlaceSuggestion], Error>>.Continuation
    
    init(region: MKCoordinateRegion? = nil) {
        (suggestionsStream, suggestionContinuation) = AsyncStream.makeStream()
        
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        if let region {
            completer.region = region
            completer.regionPriority = .required
        }
    }
    
    func updateQuery(_ query: String) {
        let trimmedQuery = query.trimmed
        completer.queryFragment = trimmedQuery
        if trimmedQuery.isEmpty {
            publish([])
        }
    }
    
    func coordinate(for placeSuggestion: PlaceSuggestion) async throws -> Coordinate? {
        do {
            guard let mkCompletion = completionsById[placeSuggestion.id] else {
                throw PlaceSearchError.suggestionNotFound
            }
            
            let request = MKLocalSearch.Request(completion: mkCompletion)
            let response = try await MKLocalSearch(request: request)
                .start()
            
            guard let mapItem = response.mapItems.first else {
                throw PlaceSearchError.noResults
            }
            
            let coordinate2d: CLLocationCoordinate2D
            if #available(iOS 26.0, *) {
                coordinate2d = mapItem.location.coordinate
            } else {
                coordinate2d = mapItem.placemark.coordinate
            }
            
            return coordinate2d.coordiante
            
        } catch {
            throw mapError(error)
        }
    }
    
    func updateRegion(center: Coordinate, latitudeDelta: Double, longitudeDelta: Double) {
        completer.region = MKCoordinateRegion(
            center: center.clLocationCoordinate2d,
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
        completer.regionPriority = .required
    }
    
    private func publish(_ mkCompletions: [MKLocalSearchCompletion]) {
        var newCompletionsById: [PlaceSuggestion.ID: MKLocalSearchCompletion] = [:]
        
        let newPlaceSuggestions: [PlaceSuggestion] = mkCompletions.map { completion in
            let placeSuggestion = PlaceSuggestion(
                id: UUID().uuidString,
                title: completion.title,
                subtitle: completion.subtitle
            )
            
            newCompletionsById[placeSuggestion.id] = completion
            
            return placeSuggestion
        }
        completionsById = newCompletionsById
        suggestionContinuation.yield(.success(newPlaceSuggestions))
    }
    
    private func publish(_ error: Error) {
        completionsById = [:]
        suggestionContinuation.yield(.failure(error))
    }
}

extension DefaultPlaceSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        publish(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        publish(error)
    }
}

extension DefaultPlaceSearchService {
    private func mapError(_ error: Error) -> Error {
        switch error {
        case let urlError as URLError:
            NetworkError.init(from: urlError)
            
        case let mkError as MKError:
            PlaceSearchError(mkError)
            
        default:
            error
        }
    }
}

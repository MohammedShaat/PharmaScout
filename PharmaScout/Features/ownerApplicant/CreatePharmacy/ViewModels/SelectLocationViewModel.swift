//
//  SelectLocationViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

@Observable
class SelectLocationViewModel {
    private let locationService: LocationService
    private let geocodingService: GeocodingService
    private let placeSearchService: PlaceSearchService
    
    private let maxPinLatitudeSpan = AppConstants.Pharmacy.maxPinLatitudeSpan
    
    private(set) var selectedCoordiante: Coordinate?

    var searchText = ""
    private var lastSearchText = ""
   
    private(set) var suggestions: [PlaceSuggestion] = []

    private(set) var resolvedPlace: ResolvedPlace?
    
    var suggestionsLoadingState = LoadingState()
    var reverseGeocodingLoadingState = LoadingState()
    var placeSearchingLoadingState = LoadingState()
    
    init(locationService: LocationService, geocodingService: GeocodingService, placeSearchService: PlaceSearchService) {
        self.locationService = locationService
        self.geocodingService = geocodingService
        self.placeSearchService = placeSearchService
    }
    
    func requestLocationPermission() {
        locationService.requestPermission()
    }
    
    func updateQuery() async {
        let shouldPerform = SearchRequestPolicy.shouldPerform(
            query: searchText,
            lastQuery: lastSearchText,
            hasPreviousPage: false,
            isRefreshing: false,
        )
        await SearchRequestPolicy.perform(
            shouldPerform: shouldPerform,
            hasPreviousPage: false,
            isRefreshing: false,
            startLoading: {
                suggestionsLoadingState.startLoading()
            },
            query: searchText) {
                lastSearchText = searchText.trimmed
            } work: {
                placeSearchService.updateQuery(searchText)
            }
    }
    
    func searchPlace(for placeSuggestion: PlaceSuggestion, onSuccess: () -> Void) async {
        placeSearchingLoadingState.startLoading()
        defer { placeSearchingLoadingState.stopLoading() }
        
        do {
            let newCoordiante = try await placeSearchService.coordinate(for: placeSuggestion)

            selectedCoordiante = newCoordiante ?? selectedCoordiante
            searchText = placeSuggestion.title
            
            onSuccess()
            
        } catch {
            placeSearchingLoadingState.fail(error)
            print("Place search failed\n", error)
        }
    }
    
    func updateRegion(center: Coordinate, latitudeDelta: Double, longitudeDelta: Double) {
        selectedCoordiante = latitudeDelta <= maxPinLatitudeSpan ? center : nil
        
        placeSearchService.updateRegion(center: center, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    func observeSuggestionsStream() async {
        for await result in placeSearchService.suggestionsStream {
            switch result {
            case .success(let newSuggestions):
                self.suggestions = newSuggestions
                suggestionsLoadingState.stopLoading()
                
            case .failure(let error):
                self.suggestions = []
                suggestionsLoadingState.fail(error)
            }
        }
    }
    
    func confirmLocation(onCompletion: ((Coordinate, ResolvedPlace) -> Void)? = nil) async {
        guard let selectedCoordiante else {
            reverseGeocodingLoadingState.fail(ReversePlaceError.regionTooBroad)
            print("no selected coordiante (nil)")
            return
        }
        
        await reverseGeocode()
        
        onCompletion?(selectedCoordiante, resolvedPlace ?? .empty)
    }
    
    private func reverseGeocode() async {
        guard let selectedCoordiante else {
            reverseGeocodingLoadingState.fail(ReversePlaceError.regionTooBroad)
            print("no selected coordiante (nil)")
            return
        }
        
        reverseGeocodingLoadingState.startLoading()
        defer { reverseGeocodingLoadingState.stopLoading() }
        
        do {
            resolvedPlace = try await geocodingService.reverseGeocode(selectedCoordiante)
            
        } catch {
            reverseGeocodingLoadingState.fail(error)
            print("Reverse geocoding failed\n", error)
        }
    }
}

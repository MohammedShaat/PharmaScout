//
//  SearchDetailViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import Foundation

@Observable
class SearchDetailViewModel {
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    let search: Search
    
    private(set) var userCoordinate: Coordinate?
    
    private(set) var searchDrugDetails: [SearchDrugDetail] = []
    private(set) var loadingState = LoadingState()
    
    init(
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        search: Search
    ) {
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.search = search
    }
    
    func loadSearchDetail(refresh: Bool = false) async {
        getLocation()
        guard let userCoordinate else {
            loadingState.fail(LocationError.unableToDetermineLocation)
            return
        }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = SearchDrugDetailsParams(
                latitude: userCoordinate.latitude,
                longitude: userCoordinate.longitude,
                searchId: search.id
            )
            searchDrugDetails = try await searchRequestService.getSearchDrugDetails(params)
            
        } catch {
            loadingState.fail(error)
            print("Failed to load search details\n", error)
        }
    }
    
    func refresh() async {
        await loadSearchDetail(refresh: true)
    }
    
    private func getLocation() {
        guard userCoordinate == nil else { return }
        
        locationService.requestPermission()
        
        do {
            userCoordinate = try locationService.getCurrentLocation()
            
        } catch {
            loadingState.fail(error)
            print("Failed to get location\n", error)
        }
    }
}

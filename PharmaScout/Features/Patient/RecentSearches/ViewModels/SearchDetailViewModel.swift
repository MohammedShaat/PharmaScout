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
    private let appConfigService: AppConfigService
    private let searchId: String
    
    private(set) var search: Search?
    private(set) var userCoordinate: Coordinate?
    private(set) var searchDrugDetails: [SearchDrugDetail] = []
    
    private let initialDistanceStep: Double = AppConstants.Search.initialDistanceStep

    var distanceMeters: Double = 0
    private(set) var minDistanceMeters: Double?
    private(set) var maxDistanceMeters: Double?
    
    private(set) var showExpandRadius: Bool = false

    private(set) var searchLoadingState = LoadingState()
    private(set) var detailLoadingState = LoadingState()
    private(set) var distanceConfigsLoadingState = LoadingState()
    private(set) var continueSearchLoadingState = LoadingState()
    
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        appConfigService: AppConfigService,
        searchId: String,
        search: Search?
    ) {
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.appConfigService = appConfigService
        self.searchId = searchId
        self.search = search
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadSearchAndDetailIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await getMaxDistanceMeter()
            
            let refresh = search != nil
            async let getSearch = getSearch(refresh: refresh)
            async let loadSearchDetail = loadSearchDetail()
            
            _ = await (getSearch, loadSearchDetail)
        }
    }
    
    func refresh() async {
        if maxDistanceMeters == nil {
            await getMaxDistanceMeter()
        }
        
        async let getSearch = getSearch(refresh: true)
        async let loadSearchDetail = loadSearchDetail(refresh: true)
        
        _ = await (getSearch, loadSearchDetail)
    }
    
    func continueSearch(refresh: Bool = false) async {
        continueSearchLoadingState.startLoading(refresh: refresh)
        defer { continueSearchLoadingState.stopLoading() }
        
        do {
            let request = ContinueSearchRequest(searchId: searchId, radiusMeters: distanceMeters)
            let pharmacyCount = try await searchRequestService.continueSearch(request: request)
            
            if pharmacyCount == 0 {
                continueSearchLoadingState.fail(ContinueSearchError.noPharmaciesWithinRadius)
                showExpandRadius = true
            }
            
            await getSearch(refresh: true)
            
        } catch {
            continueSearchLoadingState.fail(error)
            print("Failed to expand search\n", error)
        }
    }
    
    private func getSearch(refresh: Bool = false) async {
        searchLoadingState.startLoading(refresh: refresh)
        defer { searchLoadingState.stopLoading() }
        
        do {
            let newSearch = try await searchRequestService.getSearch(for: searchId)
            search = newSearch
            distanceMeters = newSearch.radiusMeters + initialDistanceStep
            minDistanceMeters = newSearch.radiusMeters
            
        } catch {
            searchLoadingState.fail(error)
            print("Failed to get search\n", error)
        }
    }
    
    private func loadSearchDetail(refresh: Bool = false) async {
        getLocation()
        guard let userCoordinate else {
            detailLoadingState.fail(LocationError.unableToDetermineLocation)
            return
        }
        
        detailLoadingState.startLoading(refresh: refresh)
        defer { detailLoadingState.stopLoading() }
        
        do {
            let params = SearchDrugDetailsParams(
                latitude: userCoordinate.latitude,
                longitude: userCoordinate.longitude,
                searchId: searchId
            )
            searchDrugDetails = try await searchRequestService.getSearchDrugDetails(params)
            
        } catch {
            detailLoadingState.fail(error)
            print("Failed to load search details\n", error)
        }
    }
    
    private func getMaxDistanceMeter(refresh: Bool = false) async {
        distanceConfigsLoadingState.startLoading(refresh: refresh)
        defer { distanceConfigsLoadingState.stopLoading() }
        
        do {
            maxDistanceMeters = try await appConfigService.getMaxSearchRadiusMeters()
            
        } catch {
            distanceConfigsLoadingState.fail(error)
            print("Failed to get max search sistance meters\n", error)
        }
    }
    
    private func getLocation() {
        guard userCoordinate == nil else { return }
        
        locationService.requestPermission()
        
        do {
            userCoordinate = try locationService.getCurrentLocation()
            
        } catch {
            detailLoadingState.fail(error)
            print("Failed to get location\n", error)
        }
    }
    
    func onShowExpandTapped() {
        showExpandRadius = true
    }
}

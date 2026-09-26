//
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import Foundation

@Observable
class SearchViewModel {
    private let searchRequestService: SearchRequestService
    private let authService: AuthService
    private let locationService: LocationService
    private let pharmacySerivce: PharmacyService
    
    private(set) var selectedDrugs: [SelectedDrug] = []
    private var numberOfActiveSearchs: Int?

    var acceptSubstitutes: Bool = true
    var fulfilmentMode: FulfilmentMode = .singlePharmacy
    
    let minPharmacyCount: Int = AppConstants.Search.minimumPharmacyCount
    let pharmacyLimit: Int = AppConstants.Search.defaultPharmacyCount
    
    let minDistanceMeters: Double = AppConstants.Search.minSearchDistanceMeters
    let maxDistanceMeters: Double = AppConstants.Search.maxSearchDistanceMeters
    var distanceMeters: Double = AppConstants.Search.defaultSearchDistanceMeters
    
    let maxDrugsPerRequest: Int = AppConstants.Search.maxDrugsPerRequest
    var canAddDrug: Bool { selectedDrugs.count < maxDrugsPerRequest }
    
    let maxActiveSearches: Int = AppConstants.Search.maxPendingRequests
    var hasReachedSearchLimit: Bool { numberOfActiveSearchs ?? 0 >= maxActiveSearches }
    var canStartSearch: Bool { !hasReachedSearchLimit && selectedDrugs.isNotEmpty }

    private(set) var activeSearchsLoadingState: LoadingState = LoadingState()
    private(set) var requestLoadingState: LoadingState = LoadingState()
    var showNoPharmaciesMessage: Bool = false
    var showSuccessMessage: Bool = false

    init(
        searchRequestService: SearchRequestService,
        authService: AuthService,
        locationService: LocationService,
        pharmacySerivce: PharmacyService,
    ) {
        self.searchRequestService = searchRequestService
        self.authService = authService
        self.locationService = locationService
        self.pharmacySerivce = pharmacySerivce
    }

    func addDrug(selectedDrug: SelectedDrug) {
        selectedDrugs.append(selectedDrug)
    }

    func cancelDrug(id: String) {
        selectedDrugs.removeAll { $0.id == id }
    }
    
    func getNumberOfActiveSearchs() async {
        guard numberOfActiveSearchs == nil else { return }
        
        activeSearchsLoadingState.startLoading()
        defer { activeSearchsLoadingState.stopLoading() }
        
        do {
            let userId = try await authService.getUser().id
            numberOfActiveSearchs = try await searchRequestService.getNumberOfActiveSearchs(userId: userId)
            
        } catch {
            activeSearchsLoadingState.fail(error)
            print("Failed to get number of active searchs\n", error)
        }
    }
    
    func startSearch() async {
        guard canStartSearch else { return }
        
        requestLoadingState.startLoading()
        defer { requestLoadingState.stopLoading() }
        
        locationService.requestPermission()
        
        do {
            let coordinate = try locationService.getCurrentLocation()
            
            let nearbyPharmacies = try await pharmacySerivce.findOpenNearbyPharmacies(
                coordinate: coordinate,
                radiusMeters: distanceMeters,
                count: pharmacyLimit,
            )
            
            guard nearbyPharmacies.isNotEmpty else {
                showNoPharmaciesMessage = true
                return
            }
            
            try await createSearchRequest(coordinate: coordinate, pharmacies: nearbyPharmacies)
            
            showSuccessMessage = true
            await refresh()
            clear()

        } catch {
            requestLoadingState.fail(error)
            print("Failed to create search\n", error)
        }
    }
    
    func refresh() async {
        numberOfActiveSearchs = nil
        await getNumberOfActiveSearchs()
    }
    
    private func createSearchRequest(coordinate: Coordinate, pharmacies: [NearbyPharmacy]) async throws {
        let request = SearchRequest(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            fulfilmentMode: fulfilmentMode,
            acceptSubstitute: acceptSubstitutes,
            drugs: selectedDrugs.map { SearchItemRequest(from: $0) },
            pharmacies: pharmacies
        )
        
        try await searchRequestService.createSearchRequest(request: request)
    }
        
    private func clear() {
        selectedDrugs.removeAll()
    }
}

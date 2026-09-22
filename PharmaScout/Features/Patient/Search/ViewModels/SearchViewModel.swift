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
    
    var requestError: AppError?
    var isLoading: Bool = false
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
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userId = try await authService.getUser().id
            numberOfActiveSearchs = try await searchRequestService.getNumberOfActiveSearchs(userId: userId)
            
        } catch {
            requestError = ErrorHandler.handle(error)
            print("Failed to get number of active searchs\n", error)
        }
    }
    
    func startSearch() async {
        guard canStartSearch else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        locationService.requestPermission()
        
        do {
            let location = try locationService.getCurrentLocation()
            
            let nearbyPharmacies = try await pharmacySerivce.findOpenNearbyPharmacies(
                latitude: location.latitude,
                longitude: location.longitude,
                radiusMeters: distanceMeters,
                count: pharmacyLimit,
            )
            
            guard nearbyPharmacies.isNotEmpty else {
                showNoPharmaciesMessage = true
                return
            }
            
            try await createSearchRequest(location: location, pharmacies: nearbyPharmacies)
            
            showSuccessMessage = true
            await refresh()
            clear()

        } catch {
            requestError = ErrorHandler.handle(error)
            print("Failed to create search\n", error)
        }
    }
    
    func refresh() async {
        numberOfActiveSearchs = nil
        await getNumberOfActiveSearchs()
    }
    
    private func createSearchRequest(location: UserLocation, pharmacies: [NearbyPharmacy]) async throws {
        let request = SearchRequest(
            latitude: location.latitude,
            longitude: location.longitude,
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

//
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import Foundation

@Observable
class SearchViewModel {
    private let userId: String
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    
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

    private(set) var numberOfActiveSearchsLoadingState: LoadingState = LoadingState()
    var requestLoadingState: LoadingState = LoadingState()
    var showNoPharmaciesMessage: Bool = false
    var showSuccessMessage: Bool = false
    
    private var hasStarted: Bool = false

    init(
        userId: String,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
    ) {
        self.userId = userId
        self.searchRequestService = searchRequestService
        self.locationService = locationService
    }

    func addDrug(selectedDrug: SelectedDrug) {
        selectedDrugs.append(selectedDrug)
    }

    func cancelDrug(id: String) {
        selectedDrugs.removeAll { $0.id == id }
    }
    
    func refresh() async {
        await getNumberOfActiveSearchs(refresh: true)
    }
    
    func getNumberOfActiveSearchs(refresh: Bool = false) async {
        numberOfActiveSearchsLoadingState.startLoading(refresh: refresh)
        defer { numberOfActiveSearchsLoadingState.stopLoading() }
        
        do {
            numberOfActiveSearchs = try await searchRequestService.getNumberOfActiveSearchs(userId: userId)
            
        } catch {
            numberOfActiveSearchsLoadingState.fail(error)
            print("Failed to get number of active searchs\n", error)
        }
        hasStarted = true
    }
    
    func startSearch() async {
        guard canStartSearch else { return }
        
        requestLoadingState.startLoading()
        defer { requestLoadingState.stopLoading() }
        
        locationService.requestPermission()
        
        do {
            let coordinate = try locationService.getCurrentLocation()
            
            let request = SearchRequest(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radiusMeters: distanceMeters,
                fulfilmentMode: fulfilmentMode,
                acceptSubstitute: acceptSubstitutes,
                drugs: selectedDrugs.map { SearchItemRequest(from: $0) },
            )
            
            try await searchRequestService.createSearchRequest(request: request)
            
            showSuccessMessage = true
            await refresh()
            clear()

        } catch {
            requestLoadingState.fail(error)
            print("Failed to create search\n", error)
        }
    }
    
    private func clear() {
        selectedDrugs.removeAll()
    }
    
    func listenToChanges() async {
        do {
            try await changesListener(
                needsCatchup: hasStarted,
                realtimeStream: { try await searchRequestService.subscribeToUserSearchsChanges(userId: userId) },
                trigger: refresh
            )
            
        } catch {
            print("Failed to subscribe to searches chagnes")
        }
    }
}

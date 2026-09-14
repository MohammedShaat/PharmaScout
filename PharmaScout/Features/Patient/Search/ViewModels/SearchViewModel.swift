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
    private let locationService: LocationService
    private let pharmacySerivce: PharmacyService
    
    private(set) var selectedDrugs: [SelectedDrug] = []

    var acceptSubstitutes: Bool = true
    var fulfilmentMode: FulfilmentMode = .singlePharmacy
    
    let minPharmacyCount: Int = AppConstants.Search.minimumPharmacyCount
    let pharmacyLimit: Int = AppConstants.Search.defaultPharmacyCount
    let minDistanceMeters: Double = AppConstants.Search.minSearchDistanceMeters
    let maxDistanceMeters: Double = AppConstants.Search.maxSearchDistanceMeters
    var distanceMeters: Double = AppConstants.Search.defaultSearchDistanceMeters

    var canAddDrug: Bool { selectedDrugs.count < AppConstants.Search.maxDrugsPerRequest }
    var canStartSearch: Bool { selectedDrugs.isNotEmpty }
    
    var requestError: AppError?
    var isLoading: Bool = false
    var showNoPharmaciesMessage: Bool = false
    var showSuccessMessage: Bool = false

    init(searchRequestService: SearchRequestService, locationService: LocationService, pharmacySerivce: PharmacyService) {
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.pharmacySerivce = pharmacySerivce
    }

    func addDrug(selectedDrug: SelectedDrug) {
        selectedDrugs.append(selectedDrug)
    }

    func cancelDrug(id: String) {
        selectedDrugs.removeAll { $0.id == id }
    }
    
    func startSearch() async {
        guard canStartSearch else { return }
        
        defer {
            isLoading = false
        }
        
        locationService.requestPermission()
        
        do {
            isLoading = true
            
            let location = try locationService.getCurrentLocation()
            
            let nearbyPharmacies = try await pharmacySerivce.findNearbyPharmacies(
                latitude: location.latitude,
                longitude: location.longitude,
                radiusMeters: distanceMeters,
                count: pharmacyLimit,
            )
            print("nearbyPharmacies within(\(distanceMeters.meterToKilometer)km): ", nearbyPharmacies.count)
            
            guard nearbyPharmacies.isNotEmpty else {
                showNoPharmaciesMessage = true
                return
            }
            
            try await createSearchRequest(location: location, pharmacies: nearbyPharmacies)
            showSuccessMessage = true

//            clear()
        } catch {
            requestError = ErrorHandler.handle(error)
            print("Failed to create search\n", error)
        }
        
        isLoading = false
    }
    
    private func createSearchRequest(location: UserLocation, pharmacies: [NearbyPharmacy]) async throws {
        let request = SearchRequest(
            latitude: location.latitude,
            longitude: location.longitude,
            fulfilmentMode: fulfilmentMode,
            acceptSubstitute: acceptSubstitutes,
            items: selectedDrugs.map { SearchItemRequest(from: $0) },
            pharmacies: pharmacies
        )
        
        try await searchRequestService.createSearchRequest(request: request)
    }
        
    private func clear() {
        selectedDrugs.removeAll()
    }
}

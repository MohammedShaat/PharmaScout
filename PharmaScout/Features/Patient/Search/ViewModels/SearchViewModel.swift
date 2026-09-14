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

    var canAddDrug: Bool { selectedDrugs.count < AppConstants.Search.maxDrugsPerRequest }
    var canStartSearch: Bool { selectedDrugs.isNotEmpty }
    
    var requestError: AppError?
    var isLoading: Bool = false
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
        
        locationService.requestPermission()
        
        do {
            isLoading = true
            
            let location = try locationService.getCurrentLocation()
            
            let nearbyPharmacies = try await pharmacySerivce.getNearbyPharmacies(
                latitude: location.latitude,
                longitude: location.longitude,
                radiusMeters: 3000
            )
            print("nearbyPharmacies: ", nearbyPharmacies.count)
            
//            try await createSearchRequest(location: location)
//            showSuccessMessage = true

            clear()
        } catch {
            requestError = ErrorHandler.handle(error)
            print("Failed to create search\n", error)
        }
        
        isLoading = false
    }
    
    private func createSearchRequest(location: UserLocation) async throws {
        let request = SearchRequest(
            latitude: location.latitude,
            longitude: location.longitude,
            fulfilmentMode: fulfilmentMode,
            acceptSubstitute: acceptSubstitutes,
            items: selectedDrugs.map { SearchItemRequest(from: $0) }
        )
        
        try await searchRequestService.createSearchRequest(request: request)
    }
        
    private func clear() {
        selectedDrugs.removeAll()
    }
}

//
//  PharmaciesViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/22/26.
//

import Foundation

@Observable
class PharmaciesViewModel {
    private let pharmacyService: PharmacyService
    private let locationService: LocationService
    
    private(set) var nearbyPharmacies: [Pharmacy] = []

    private var location: UserLocation?    
    var pharmaciesError: AppError?
    private(set) var loadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private(set) var radiusKm: Double = 5
    
    private(set) var canExpandRadius: Bool = false
    
    init(pharmacyService: PharmacyService, locationService: LocationService) {
        self.pharmacyService = pharmacyService
        self.locationService = locationService
    }
    
    func findNearbyPharmacies(refresh: Bool = false) async {
        await getLocation()
        guard let location else { return }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = FindNearbyPharmaciesParams(
                latitude: location.latitude,
                longitude: location.longitude,
                radiusMeters: radiusKm.kilometerToMeter,
                limit: refresh ? nearbyPharmacies.count : loadingState.pagination.pageSize,
                offset: refresh ? 0 : nearbyPharmacies.count
            )
            
            let newNearbyPharmacies = try await pharmacyService.findNearbyPharmacies(params: params)
            
            if refresh {
                nearbyPharmacies = newNearbyPharmacies
                
            } else {
                nearbyPharmacies.append(contentsOf: newNearbyPharmacies)
                
                if newNearbyPharmacies.isNotEmpty {
                    loadingState.pagination.nextPage()
                }
                
                canExpandRadius =
                    newNearbyPharmacies.count < loadingState.pagination.pageSize
                    ? true : false
            }
            
        } catch {
            pharmaciesError = ErrorHandler.handle(error)
            print("Failed to find nearby pharmacies\n", error)
        }
    }
    
    func loadMore() async {
        await findNearbyPharmacies()
    }
    
    func searchFurther() async {
        switch radiusKm {
        case 0...10: radiusKm *= 2
        default: radiusKm += 10
        }
        await findNearbyPharmacies()
    }
    
    func refresh() async {
        await findNearbyPharmacies(refresh: true)
    }
    
    private func getLocation() async {
        guard location == nil else { return }
        
        locationService.requestPermission()
        
        do {
            location = try locationService.getCurrentLocation()
            
        } catch {
            pharmaciesError = ErrorHandler.handle(error)
            print("Failed to get location\n", error)
        }
    }
}

struct LoadingState {
    var status: State = .idle
    var pagination: Pagination
    
    init(pageSize: Int) {
        pagination = .init(pageSize: pageSize)
    }
    
    mutating func startLoading(refresh: Bool = false) {
        if refresh {
            status = .refreshing
        } else {
            status = pagination.page != 0 ? .loadingMore : .loading
        }
    }
    
    mutating func stopLoading() {
        status = .idle
    }
    
    enum State {
        case idle
        case loading
        case loadingMore
        case refreshing
    }
}

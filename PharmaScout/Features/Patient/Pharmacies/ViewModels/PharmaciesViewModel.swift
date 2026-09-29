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

    private(set) var userCoordinate: Coordinate?    
    private(set) var loadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private(set) var radiusMeters: Double = AppConstants.Search.minBrowseDistanceMeters
    private let maxRadiusMeters: Double = AppConstants.Search.maxBrowseDistanceMeters
    private(set) var expandToNextRadius: Bool = false
    var canExpandRadius: Bool {
        expandToNextRadius && radiusMeters < maxRadiusMeters
    }
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService, locationService: LocationService) {
        self.pharmacyService = pharmacyService
        self.locationService = locationService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadNearbyPharmaciesIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadNearbyPharmacies()
        }
    }
    
    func loadMore() async {
        await loadNearbyPharmacies()
    }
    
    func searchFurther() async {
        switch radiusMeters.meterToKilometer {
        case 0...10: radiusMeters *= 2
        default: radiusMeters += 10
        }
        await loadNearbyPharmacies()
    }
    
    func refresh() async {
        await loadNearbyPharmacies(refresh: true)
    }
    
    private func loadNearbyPharmacies(refresh: Bool = false) async {
        getLocation()
        guard let userCoordinate else {
            loadingState.fail(LocationError.unableToDetermineLocation)
            return
        }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = FindNearbyPharmaciesParams(
                latitude: userCoordinate.latitude,
                longitude: userCoordinate.longitude,
                radiusMeters: radiusMeters,
                limit: refresh ? max(nearbyPharmacies.count, loadingState.pagination.pageSize) : loadingState.pagination.pageSize,
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
                
                expandToNextRadius =
                    newNearbyPharmacies.count < loadingState.pagination.pageSize
                    ? true : false
            }
            
        } catch {
            loadingState.fail(error)
            print("Failed to find nearby pharmacies\n", error)
        }
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

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
    
    init(pharmacyService: PharmacyService, locationService: LocationService) {
        self.pharmacyService = pharmacyService
        self.locationService = locationService
    }
    
    func findNearbyPharmacies(refresh: Bool = false) async {
        await getLocation()
        guard let userCoordinate else { return }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = FindNearbyPharmaciesParams(
                latitude: userCoordinate.latitude,
                longitude: userCoordinate.longitude,
                radiusMeters: radiusMeters,
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
                
                expandToNextRadius =
                    newNearbyPharmacies.count < loadingState.pagination.pageSize
                    ? true : false
            }
            print("nearybyPharmacies: ", nearbyPharmacies.count)
            
        } catch {
            loadingState.fail(error)
            print("Failed to find nearby pharmacies\n", error)
        }
    }
    
    func loadMore() async {
        await findNearbyPharmacies()
    }
    
    func searchFurther() async {
        switch radiusMeters.meterToKilometer {
        case 0...10: radiusMeters *= 2
        default: radiusMeters += 10
        }
        await findNearbyPharmacies()
    }
    
    func refresh() async {
        await findNearbyPharmacies(refresh: true)
    }
    
    private func getLocation() async {
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

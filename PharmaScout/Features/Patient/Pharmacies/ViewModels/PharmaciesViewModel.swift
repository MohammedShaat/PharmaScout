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
        guard let userCoordinate else { return }
        
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            let params = FindNearbyPharmaciesParams(
                latitude: userCoordinate.latitude,
                longitude: userCoordinate.longitude,
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
            print("nearybyPharmacies: ", nearbyPharmacies.count)
            
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
        guard userCoordinate == nil else { return }
        
        locationService.requestPermission()
        
        do {
            userCoordinate = try locationService.getCurrentLocation()
            
        } catch {
            pharmaciesError = ErrorHandler.handle(error)
            print("Failed to get location\n", error)
        }
    }
}

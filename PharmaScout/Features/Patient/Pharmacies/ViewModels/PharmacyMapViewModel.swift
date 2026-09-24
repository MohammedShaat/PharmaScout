//
//  PharmacyMapViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation

@Observable
class PharmacyMapViewModel {
    let pharmacy: Pharmacy
    let userCoordinate: Coordinate
    private let directionsService: DirectionsService
    
    private(set) var route: MapRoute?
    
    private(set) var routeLoadingState: LoadingState = .init(pageSize: AppConstants.Network.pageSize)
    
    init(pharmacy: Pharmacy, userCoordinate: Coordinate, directionsService: DirectionsService) {
        self.pharmacy = pharmacy
        self.userCoordinate = userCoordinate
        self.directionsService = directionsService
    }
    
    func loadRoute() async {
        routeLoadingState.startLoading()
        defer { routeLoadingState.stopLoading() }
        
        do {
            route = try await directionsService.calculateRoute(
                from: userCoordinate,
                to: pharmacy.coordinate
            )
            
        } catch {
            routeLoadingState.fail(error)
            print("Failed to calculate route:", error)
        }
    }
}

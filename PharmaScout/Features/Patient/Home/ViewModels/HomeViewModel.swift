//
//  HomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class HomeViewModel {
    private let authService: AuthService
    private let locationService: LocationService
    private let pharmacyService: PharmacyService
    private let searchRequestService: SearchRequestService
    
    private(set) var user: AppUser?
    private(set) var userName: String = ""
    var hasUnreadNotifications: Bool = true
    
    private(set) var nearbyPharmacies: [Pharmacy] = []
    
    private var locationCoordinate: Coordinate?
    var locationError: AppError?
    private(set) var nearbyPharmaciesLoadingState: LoadingState = .init(pageSize: AppConstants.Network.pageSize)
    
    private let nearbyPharmaciesLimit: Int = 3
    private(set) var radiusMeters: Double = AppConstants.Search.minBrowseDistanceMeters
    private let maxRadiusMeters: Double = AppConstants.Search.maxBrowseDistanceMeters
    
    private(set) var recentSearches: [Search] = []
    private(set) var recentSearchesloadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    private let recentSearchesLimit: Int = 3
    
    init(
        authService: AuthService,
        locationService: LocationService,
        pharmacyService: PharmacyService,
        searchRequestService: SearchRequestService
    ) {
        self.authService = authService
        self.locationService = locationService
        self.pharmacyService = pharmacyService
        self.searchRequestService = searchRequestService
    }
    
    func loadUserData() async {
        user = try? await authService.getUser()
    }
    
    func getLocation() {
        locationService.requestPermission()
        do {
            locationCoordinate = try locationService.getCurrentLocation()
            
        } catch {
            locationError = ErrorHandler.handle(error)
            print("Failed to get location\n", error)
        }
    }
    
    func loadNearbyPharmacies(refresh: Bool = false) async {
        guard let locationCoordinate else { return }
        
        nearbyPharmaciesLoadingState.startLoading(refresh: refresh)
        defer { nearbyPharmaciesLoadingState.stopLoading() }
        
        do {
            var keepSearching = refresh
            while (nearbyPharmacies.count < nearbyPharmaciesLimit && radiusMeters <= maxRadiusMeters)
            || keepSearching {
                let params = FindNearbyPharmaciesParams(
                    latitude: locationCoordinate.latitude,
                    longitude: locationCoordinate.longitude,
                    radiusMeters: radiusMeters,
                    limit: nearbyPharmaciesLimit,
                    offset: refresh ? 0 : nearbyPharmacies.count
                )
                
                let newPharmacies = try await pharmacyService.findNearbyPharmacies(params: params)
                
                if refresh {
                    nearbyPharmacies = newPharmacies
                    keepSearching = nearbyPharmacies.count < nearbyPharmaciesLimit
                } else {
                    nearbyPharmacies.append(
                        contentsOf: newPharmacies.prefix(nearbyPharmaciesLimit - nearbyPharmacies.count)
                    )
                }
                
                if nearbyPharmacies.count < nearbyPharmaciesLimit {
                    expandRadius()
                }
            }
            
        } catch {
            nearbyPharmaciesLoadingState.fail(error)
            print("failed to get nearest pharmacies\n", error)
        }
    }
    
    func loadRecentSearches(refresh: Bool = false) async {
        recentSearchesloadingState.startLoading(refresh: refresh)
        defer { recentSearchesloadingState.stopLoading() }
        
        do {
            let newSearchs = try await searchRequestService.getSearches(
                limit: recentSearchesLimit,
                offset: refresh ? 0 : recentSearches.count
            )
            
            if refresh {
                recentSearches = newSearchs
            } else {
                recentSearches.append(contentsOf: newSearchs)
            }

            if newSearchs.isNotEmpty {
                recentSearchesloadingState.pagination.nextPage()
            }
            
        } catch {
            recentSearchesloadingState.fail(error)
            print("Failed to load recent searches\n", error)
        }
    }
    
    func refresh() async {
        await loadNearbyPharmacies(refresh: true)
        await loadRecentSearches(refresh: true)
    }
    
    private func expandRadius() {
        switch radiusMeters.meterToKilometer {
        case 0...20: radiusMeters *= 2
        default: radiusMeters += 10
        }
    }
}

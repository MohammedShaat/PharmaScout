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
    private(set) var nearbyPharmaciesLoadingState: LoadingState = .init(pageSize: 3)
    
    private(set) var radiusMeters: Double = AppConstants.Search.minBrowseDistanceMeters
    private let maxRadiusMeters: Double = AppConstants.Search.maxBrowseDistanceMeters
    
    private(set) var recentSearches: [Search] = []
    private(set) var recentSearchesloadingState = LoadingState(pageSize: 3)
    
    private(set) var activeSearches: [Search] = []
    private(set) var activeSearchesloadingState = LoadingState(pageSize: 2)
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
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
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            getLocation()
            async let loadUserData = await loadUserData()
            async let loadActiveSearches = await loadActiveSearches()
            async let loadRecentSearches = await loadRecentSearches()
            async let loadNearbyPharmacies = await loadNearbyPharmacies()
            
            _ = await (loadUserData, loadActiveSearches, loadRecentSearches, loadNearbyPharmacies)
        }
    }
    
    func refresh() async {
        async let nearbyPharmacies = await loadNearbyPharmacies(refresh: true)
        async let recentSearches = await loadRecentSearches(refresh: true)
        async let activeSearches = await loadActiveSearches(refresh: true)
        
        _ = await (nearbyPharmacies, recentSearches, activeSearches)
    }
    
    private func loadUserData() async {
        user = try? await authService.getUser()
    }
    
    private func getLocation() {
        locationService.requestPermission()
        do {
            locationCoordinate = try locationService.getCurrentLocation()
            
        } catch {
            locationError = ErrorHandler.handle(error)
            print("Failed to get location\n", error)
        }
    }
    
    private func loadNearbyPharmacies(refresh: Bool = false) async {
        guard let locationCoordinate else {
            nearbyPharmaciesLoadingState.fail(LocationError.unableToDetermineLocation)
            return
        }
        
        nearbyPharmaciesLoadingState.startLoading(refresh: refresh)
        defer { nearbyPharmaciesLoadingState.stopLoading() }
        
        do {
            var keepSearching = refresh
            let limit = nearbyPharmaciesLoadingState.pagination.pageSize
            
            while (nearbyPharmacies.count < limit && radiusMeters <= maxRadiusMeters)
                    || keepSearching {
                let params = FindNearbyPharmaciesParams(
                    latitude: locationCoordinate.latitude,
                    longitude: locationCoordinate.longitude,
                    radiusMeters: radiusMeters,
                    limit: limit,
                    offset: refresh ? 0 : nearbyPharmacies.count
                )
                
                let newPharmacies = try await pharmacyService.findNearbyPharmacies(params: params)
                
                if refresh {
                    nearbyPharmacies = newPharmacies
                    keepSearching = nearbyPharmacies.count < limit
                } else {
                    nearbyPharmacies.append(
                        contentsOf: newPharmacies.prefix(limit - nearbyPharmacies.count)
                    )
                }
                
                if nearbyPharmacies.count < limit {
                    expandRadius()
                }
            }
            
        } catch {
            nearbyPharmaciesLoadingState.fail(error)
            print("failed to get nearest pharmacies\n", error)
        }
    }
    
    private func loadRecentSearches(refresh: Bool = false) async {
        recentSearchesloadingState.startLoading(refresh: refresh)
        defer { recentSearchesloadingState.stopLoading() }
        
        do {
            let params = GetSearchesParams(
                limit: recentSearchesloadingState.pagination.pageSize,
                offset: 0,
                filter: .nonPending
            )
            recentSearches = try await searchRequestService.getSearches(params)
            
        } catch {
            recentSearchesloadingState.fail(error)
            print("Failed to load recent searches\n", error)
        }
    }
    
    private func loadActiveSearches(refresh: Bool = false) async {
        activeSearchesloadingState.startLoading(refresh: refresh)
        defer { activeSearchesloadingState.stopLoading() }
        
        do {
            let params = GetSearchesParams(
                limit: activeSearchesloadingState.pagination.pageSize,
                offset: 0,
                filter: .pending
            )
            activeSearches = try await searchRequestService.getSearches(params)
            
        } catch {
            activeSearchesloadingState.fail(error)
            print("Failed to load active searches\n", error)
        }
    }
    
    private func expandRadius() {
        switch radiusMeters.meterToKilometer {
        case 0...20: radiusMeters *= 2
        default: radiusMeters += 10
        }
    }
}

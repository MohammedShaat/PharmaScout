//
//  PatientTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct PatientTabView: View {
    private let user: AppUser
    private let router: AppRouter
    private let authService: AuthService
    private let drugService: DrugService
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    private let pharmacySerivce: PharmacyService
    private let directionsService: DirectionsService
    private let pushTokenCoordinator: PushTokenCoordinator
    private let appConfigService: AppConfigService
    private let ownerApplicationService: OwnerApplicationService
    
    @State private var vm = PatientTabViewModel()
    
    init(
        user: AppUser,
        router: AppRouter,
        authService: AuthService,
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        pharmacySerivce: PharmacyService,
        directionsService: DirectionsService,
        pushTokenCoordinator: PushTokenCoordinator,
        appConfigService: AppConfigService,
        ownerApplicationService: OwnerApplicationService
    ) {
        self.user = user
        self.router = router
        self.authService = authService
        self.drugService = drugService
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.pharmacySerivce = pharmacySerivce
        self.directionsService = directionsService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.appConfigService = appConfigService
        self.ownerApplicationService = ownerApplicationService
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                HomeScreen(authService: authService, drugService: drugService, patientTabViewModel: vm, locationService: locationService, pharmacyService: pharmacySerivce, searchRequestService: searchRequestService)
            }
            
            Tab("Search", image: tabImage(.search), value: .search) {
                SearchScreen(drugService: drugService, searchRequestService: searchRequestService, authService: authService, locationService: locationService)
            }
            
            Tab("Recent", image: tabImage(.recentSearches), value: .recentSearches) {
                RecentSearchesScreen(path: $vm.recentSearchsPath, searchRequestService: searchRequestService, locationService: locationService, patientTabViewModel: vm, appConfigService: appConfigService)
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                PharmaciesScreen(path: $vm.pharmacyPath, pharmacyService: pharmacySerivce, locationService: locationService, directionsService: directionsService)
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                ProfileScreen(user: user, authService: authService, pushTokenCoordinator: pushTokenCoordinator, pharmacyService: pharmacySerivce, ownerApplicationService: ownerApplicationService)
            }
        }
        .tint(.theme.textPrimary)	
        .onChange(of: router.pendingNotificationRoute, initial: true) { oldValue, newValue in
            guard let route = router.consumePendingPatientNotificationRoute() else { return }
            vm.handle(route)
        }
    }
    
    private func tabImage(_ tab: PatientTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "home-fill" : "home"
        case .search:
            isSelected(tab) ? "magnifyingglass-plus-fill" : "magnifyingglass-plus"
        case .recentSearches:
            isSelected(tab) ? "history-thick" : "history"
        case .pharmacies:
            isSelected(tab) ? "pharmacy-fill" : "pharmacy"
        case .profile:
            isSelected(tab) ? "profile-fill" : "profile"
        }
    }
    
    private func isSelected(_ tab: PatientTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    PatientTabView(
        user: .samples[0],
        router: .sample,
        authService: MockAuthService.sample,
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        pharmacySerivce: MockPharmacyService.sample,
        directionsService: MockDirectionsSrevice.sample,
        pushTokenCoordinator: .sample,
        appConfigService: MockAppConfigService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample
    )
}

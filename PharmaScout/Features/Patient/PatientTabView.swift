//
//  PatientTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct PatientTabView: View {
    let user: AppUser
    let router: AppRouter
    let dependencies: AppDependencies
    
    @State private var vm = PatientTabViewModel()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                HomeScreen(user: user, drugService: dependencies.drugService, patientTabViewModel: vm, locationService: dependencies.locationService, pharmacyService: dependencies.pharmacyService, searchRequestService: dependencies.searchRequestService)
            }
            
            Tab("Search", image: tabImage(.search), value: .search) {
                SearchScreen(userId: user.id, drugService: dependencies.drugService, searchRequestService: dependencies.searchRequestService, locationService: dependencies.locationService, patientTabViewModel: vm)
            }
            
            Tab("Recent", image: tabImage(.recentSearches), value: .recentSearches) {
                RecentSearchesScreen(path: $vm.recentSearchsPath, userId: user.id, searchRequestService: dependencies.searchRequestService, locationService: dependencies.locationService, patientTabViewModel: vm, appConfigService: dependencies.appConfigService)
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                PharmaciesScreen(path: $vm.pharmacyPath, pharmacyService: dependencies.pharmacyService, locationService: dependencies.locationService, directionsService: dependencies.directionsService)
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                ProfileScreen(user: user, authService: dependencies.authService, pushTokenCoordinator: dependencies.pushTokenCoordinator, pharmacyService: dependencies.pharmacyService, ownerApplicationService: dependencies.ownerApplicationService, appleReauthenticationService: dependencies.appleReauthenticationService, googleReauthenticationService: dependencies.googleReauthenticationService)
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
        dependencies: .uiTesting()
    )
}

//
//  PatientTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct PatientTabView: View {
    private let authService: AuthService
    private let drugService: DrugService
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    private let pharmacySerivce: PharmacyService
    private let directionsService: DirectionsService
    
    @State private var vm = PatientTabViewModel()
    
    init(
        authService: AuthService,
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        pharmacySerivce: PharmacyService,
        directionsService: DirectionsService
    ) {
        self.authService = authService
        self.drugService = drugService
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.pharmacySerivce = pharmacySerivce
        self.directionsService = directionsService
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                HomeScreen(authService: authService, drugService: drugService, patientTabViewModel: vm, locationService: locationService, pharmacyService: pharmacySerivce)
            }
            
            Tab("Search", image: tabImage(.search), value: .search) {
                SearchScreen(drugService: drugService, searchRequestService: searchRequestService, authService: authService, locationService: locationService, pharmacySerivce: pharmacySerivce)
            }
            
            Tab("Recent", image: tabImage(.recent), value: .recent) {
                
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                PharmaciesScreen(path: $vm.pharmacyPath, pharmacyService: pharmacySerivce, locationService: locationService, directionsService: directionsService)
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                ProfileScreen(authService: authService)
            }
        }
        .tint(.theme.textPrimary)	
        
    }
    
    private func tabImage(_ tab: PatientTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "homeSelected" : "home"
        case .search:
            isSelected(tab) ? "magnifyingglassSelected" : "magnifyingglass"
        case .recent:
            isSelected(tab) ? "historySelected" : "history"
        case .pharmacies:
            isSelected(tab) ? "locationPlusSelected" : "locationPlus"
        case .profile:
            isSelected(tab) ? "profileSelected" : "profile"
        }
    }
    
    private func isSelected(_ tab: PatientTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    PatientTabView(
        authService: MockAuthService.sample,
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        pharmacySerivce: MockPharmacyService.sample,
        directionsService: MockDirectionsSrevice.sample
    )
}

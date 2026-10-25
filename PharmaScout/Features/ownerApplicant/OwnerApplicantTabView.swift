//
//  OwnerApplicantTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct OwnerApplicantTabView: View {
    private let user: AppUser
    private let ownerApplicationSummary: OwnerApplicationSummary
    private let authService: AuthService
    private let pushTokenCoordinator: PushTokenCoordinator
    private let ownerApplicationService: OwnerApplicationService
    private let pharmacyService: PharmacyService
    private let geocodingService: GeocodingService
    private let placeSearchService: PlaceSearchService
    private let locationService: LocationService
    
    @State private var vm: OwnerApplicantTabViewModel
    
    init(
        user: AppUser,
        ownerApplicationSummary: OwnerApplicationSummary,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        ownerApplicationService: OwnerApplicationService,
        pharmacyService: PharmacyService,
        geocodingService: GeocodingService,
        placeSearchService: PlaceSearchService,
        locationService: LocationService
    ) {
        self.user = user
        self.ownerApplicationSummary = ownerApplicationSummary
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.ownerApplicationService = ownerApplicationService
        self.pharmacyService = pharmacyService
        self.geocodingService = geocodingService
        self.placeSearchService = placeSearchService
        self.locationService = locationService
        
        let viewModel = OwnerApplicantTabViewModel(ownerApplicationSummary: ownerApplicationSummary)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                OwnerApplicantHomeScreen(ownerApplicantTabViewModel: vm, ownerApplicationSummary: ownerApplicationSummary, ownerApplicationService: ownerApplicationService)
            }
            
            if vm.status == .approved {
                Tab("Create Pharmacy", image: tabImage(.createPharmacy), value: .createPharmacy) {
                    CreatePharmacyScreen(pharmacyService: pharmacyService, ownerApplicationService: ownerApplicationService, geocodingService: geocodingService, placeSearchService: placeSearchService, locationService: locationService)
                }
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                OwnerApplicantProfileScreen(user: user, authService: authService, pushTokenCoordinator: pushTokenCoordinator)
            }
        }
        .tint(.theme.primary)
    }
    
    private func tabImage(_ tab: OwnerApplicantTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "home-fill" : "home"
        case .createPharmacy:
            isSelected(tab) ? "pharmacy-fill" : "pharmacy"
        case .profile:
            isSelected(tab) ? "profile-fill" : "profile"
        }
    }
    
    private func isSelected(_ tab: OwnerApplicantTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    OwnerApplicantTabView(
        user: .samples[0],
        ownerApplicationSummary: .samples[0],
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        ownerApplicationService: MockOwnerApplicationService.sample,
        pharmacyService: MockPharmacyService.sample,
        geocodingService: MockGeocodingService.sample,
        placeSearchService: MockPlaceSearchService.sample,
        locationService: MockLocationService.sample
    )
}

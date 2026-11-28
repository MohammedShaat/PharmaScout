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
    private let dependencies: AppDependencies
    
    @State private var vm: OwnerApplicantTabViewModel
    
    init(
        user: AppUser,
        ownerApplicationSummary: OwnerApplicationSummary,
        dependencies: AppDependencies
    ) {
        self.user = user
        self.ownerApplicationSummary = ownerApplicationSummary
        self.dependencies = dependencies
        
        let viewModel = OwnerApplicantTabViewModel(ownerApplicationSummary: ownerApplicationSummary)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                OwnerApplicantHomeScreen(user: user, ownerApplicantTabViewModel: vm, ownerApplicationSummary: ownerApplicationSummary)
            }
            
            if vm.status == .approved {
                Tab("Create Pharmacy", image: tabImage(.createPharmacy), value: .createPharmacy) {
                    CreatePharmacyScreen(pharmacyService: dependencies.pharmacyService, ownerApplicationService: dependencies.ownerApplicationService, geocodingService: dependencies.geocodingService, placeSearchService: dependencies.placeSearchService, locationService: dependencies.locationService)
                }
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                OwnerApplicantProfileScreen(user: user, authService: dependencies.authService, pushTokenCoordinator: dependencies.pushTokenCoordinator, appleReauthenticationService: dependencies.appleReauthenticationService, googleReauthenticationService: dependencies.googleReauthenticationService, ownerApplicationService: dependencies.ownerApplicationService)
            }
        }
        .tint(.theme.primary)
        .onChange(of: ownerApplicationSummary) {
            vm.onApplicationStatusChanged(ownerApplicationSummary: ownerApplicationSummary)
        }
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

#if DEBUG
#Preview {
    OwnerApplicantTabView(
        user: .samples[0],
        ownerApplicationSummary: .samples[0],
        dependencies: .uiTesting()
    )
}
#endif

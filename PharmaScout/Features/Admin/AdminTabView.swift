//
//  AdminTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct AdminTabView: View {
    private let authService: AuthService
    private let pushTokenCoordinator: PushTokenCoordinator
    private let ownerApplicationService: OwnerApplicationService
    private let pharmacyService: PharmacyService
    
    @State private var vm: AdminTabViewModel
    
    init(
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        ownerApplicationService: OwnerApplicationService,
        pharmacyService: PharmacyService
    ) {
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.ownerApplicationService = ownerApplicationService
        self.pharmacyService = pharmacyService
        
        let viewModel = AdminTabViewModel()
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Applications", image: tabImage(.ownerApplications), value: .ownerApplications) {
                OwnerApplicationsScreen(ownerApplicationService: ownerApplicationService)
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                AdminPharmaciesScreen(pharmacyService: pharmacyService)
            }
            
            Tab("Invite", image: tabImage(.invite), value: .invite) {
                OwnerInvitationScreen(ownerApplicationService: ownerApplicationService)
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                AdminProfileScreen(authService: authService, pushTokenCoordinator: pushTokenCoordinator)
            }
        }
        .tint(.theme.primary)
    }
    
    private func tabImage(_ tab: AdminTab) -> String {
        switch tab {
        case .ownerApplications:
            isSelected(tab) ? "clipboard-fill" : "clipboard"
        case .pharmacies:
            isSelected(tab) ? "pharmacy-fill" : "pharmacy"
        case .invite:
            isSelected(tab) ? "person-plus-fill" : "person-plus"
        case .profile:
            isSelected(tab) ? "profile-fill" : "profile"
        }
    }
    
    private func isSelected(_ tab: AdminTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    AdminTabView(
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        ownerApplicationService: MockOwnerApplicationService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

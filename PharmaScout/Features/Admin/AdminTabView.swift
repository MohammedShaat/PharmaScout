//
//  AdminTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct AdminTabView: View {
    let user: AppUser
    let dependencies: AppDependencies
    
    @State private var vm = AdminTabViewModel()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Applications", image: tabImage(.ownerApplications), value: .ownerApplications) {
                OwnerApplicationsScreen(ownerApplicationService: dependencies.ownerApplicationService)
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                AdminPharmaciesScreen(pharmacyService: dependencies.pharmacyService)
            }
            
            Tab("Invite", image: tabImage(.invite), value: .invite) {
                OwnerInvitationScreen(ownerApplicationService: dependencies.ownerApplicationService)
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                AdminProfileScreen(user: user, authService: dependencies.authService, pushTokenCoordinator: dependencies.pushTokenCoordinator, appleReauthenticationService: dependencies.appleReauthenticationService, googleReauthenticationService: dependencies.googleReauthenticationService)
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
        user: .samples[0],
        dependencies: .uiTesting()
    )
}

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
    
    @State private var vm: AdminTabViewModel
    
    init(
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        ownerApplicationService: OwnerApplicationService
    ) {
        self.authService = authService
        self.pushTokenCoordinator = pushTokenCoordinator
        self.ownerApplicationService = ownerApplicationService
        
        let viewModel = AdminTabViewModel()
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Applications", image: tabImage(.applications), value: .applications) {
                OwnerApplicationsScreen(ownerApplicationService: ownerApplicationService)
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
        case .applications:
            isSelected(tab) ? "clipboard-fill" : "clipboard"
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
        ownerApplicationService: MockOwnerApplicationService.sample
    )
}

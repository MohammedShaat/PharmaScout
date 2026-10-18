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
            Tab("Home", image: tabImage(.home), value: .home) {
                
            }
            
            Tab("Invite", image: tabImage(.invitation), value: .invitation) {
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
        case .home:
            isSelected(tab) ? "home-fill" : "home"
        case .invitation:
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

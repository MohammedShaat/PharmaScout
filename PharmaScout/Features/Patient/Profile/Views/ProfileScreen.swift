//
//  ProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct ProfileScreen: View {
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    private let ownerApplicationService: OwnerApplicationService
    
    @State private var vm: ProfileViewModel
    @State private var task: Task<Void, Never>?
    
    init(
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService,
        ownerApplicationService: OwnerApplicationService
    ) {
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.ownerApplicationService = ownerApplicationService
        
        let viewModel = ProfileViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator
        )
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            Form {
                joinPharmacy
                
                becomePharmacyOwner
                
                logout
            }
            .customBackButtonVisibility(false)
            .customNavigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .joinPharmacy:
                    JoinPharmacyScreen(authService: authService, pharmacyService: pharmacyService)
                    
                case .becomePharmacyOwner:
                    BecomePharmacyOwnerScreen(ownerApplicationService: ownerApplicationService)
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    @ViewBuilder
    private var joinPharmacy: some View {
        if vm.canJoinPharmacy {
            CustomNavValueLink(value: ProfileRoute.joinPharmacy) {
                Text("Join a pharmacy")
            }
        }
    }
    
    @ViewBuilder
    private var becomePharmacyOwner: some View {
        if vm.canJoinPharmacy {
            CustomNavValueLink(value: ProfileRoute.becomePharmacyOwner) {
                Text("Become a pharmacy owner")
            }
        }
    }
    
    private var logout: some View {
        Button {
            task?.cancel()
            task = Task {
                await vm.logout()
            }
        } label: {
            HStack {
                Text("Log out")
                
                if vm.logoutLoadingState.status != .idle {
                    RingProgressView()
                }
            }
        }
        .disabled(vm.logoutLoadingState.status != .idle)
    }
}

enum ProfileRoute {
    case joinPharmacy
    case becomePharmacyOwner
}

#Preview {
    ProfileScreen(
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        pharmacyService: MockPharmacyService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample
    )
}

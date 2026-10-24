//
//  PharmacistProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistProfileScreen: View {
    private let pharmacistAccess: PharmacistAccess
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    private let pharmacyId: String
    
    @State private var vm: PharmacistProfileViewModel
    @State private var task: Task<Void, Never>?
    
    private var canManageStaff: Bool { pharmacistAccess.can(.manageStaff) }
    
    init(
        pharmacistAccess: PharmacistAccess,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService,
        pharmacyId: String
    ) {
        self.pharmacistAccess = pharmacistAccess
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
        
        let viewModel = PharmacistProfileViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator
        )
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            Form {
                if canManageStaff {
                    invite
                }
                
                logout
            }
            .customBackButtonVisibility(false)
            .onDisappear {
                task?.cancel()
            }
            .customNavigationDestination(for: PharmacistProfileRoute.self) { route in
                switch route {
                case .joinCode:
                    JoinCodeScreen(pharmacyService: pharmacyService, pharmacyId: pharmacyId)
                }
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
    
    private var invite: some View {
        CustomNavValueLink(value: PharmacistProfileRoute.joinCode) {
            Text("Invite a pharmacist?")
        }
    }
}

enum PharmacistProfileRoute {
    case joinCode
}

#Preview {
    PharmacistProfileScreen(
        pharmacistAccess: .full(role: .owner),
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        pharmacyService: MockPharmacyService.sample,
        pharmacyId: Pharmacy.samples[0].id
    )
}

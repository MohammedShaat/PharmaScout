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
    
    @State private var vm: ProfileViewModel
    @State private var task: Task<Void, Never>?
    
    init(
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService
    ) {
        self.authService = authService
        self.pharmacyService = pharmacyService
        
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
                
                logout
            }
            .customBackButtonVisibility(false)
            .customNavigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .joinPharmacy:
                    JoinPharmacyScreen(authService: authService, pharmacyService: pharmacyService)
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
}

#Preview {
    ProfileScreen(
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        pharmacyService: MockPharmacyService.sample
    )
}

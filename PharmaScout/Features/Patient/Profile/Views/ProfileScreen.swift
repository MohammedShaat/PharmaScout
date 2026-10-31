//
//  ProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct ProfileScreen: View {
    private let user: AppUser
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    private let ownerApplicationService: OwnerApplicationService
    
    @State private var vm: ProfileViewModel
    @State private var task: Task<Void, Never>?
    @State private var showingDeleteAccountConfirmation: Bool = false
    
    init(
        user: AppUser,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService,
        ownerApplicationService: OwnerApplicationService
    ) {
        self.user = user
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
                
                deleteAccount
            }
            .customNavTitle(user.fullName ?? "")
            .customBackButtonVisibility(false)
            .alert("Delete Account?", isPresented: $showingDeleteAccountConfirmation) {
                Button("Delete Account", role: .destructive) {
                    task?.cancel()
                    task = Task {
                        await vm.deleteAccount()
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "Your account will be permanently deleted. This action cannot be undone."
                )
            }
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
        CustomNavValueLink(value: ProfileRoute.joinPharmacy) {
            Text("Join a pharmacy")
        }
    }
    
    @ViewBuilder
    private var becomePharmacyOwner: some View {
        CustomNavValueLink(value: ProfileRoute.becomePharmacyOwner) {
            Text("Become a pharmacy owner")
        }
    }
    
    private var logout: some View {
        Button("Log out") {
            task?.cancel()
            task = Task {
                await vm.logout()
            }
        }
        .disabled(vm.loadingState.status != .idle)
    }
    
    private var deleteAccount: some View {
        Button("Delete account", role: .destructive) {
            showingDeleteAccountConfirmation = true
        }
        .disabled(vm.loadingState.status != .idle)
    }
}

enum ProfileRoute {
    case joinPharmacy
    case becomePharmacyOwner
}

#Preview {
    ProfileScreen(
        user: .samples[0],
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        pharmacyService: MockPharmacyService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample
    )
}

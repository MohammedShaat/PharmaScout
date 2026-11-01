//
//  PharmacistProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistProfileScreen: View {
    private let user: AppUser
    private let pharmacistAccess: PharmacistAccess
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    private let pharmacyId: String
    
    @State private var vm: PharmacistProfileViewModel
    @State private var task: Task<Void, Never>?
    @State private var showingDeleteAccountConfirmation: Bool = false
    @State private var showingClosePharmacyConfirmation: Bool = false
    
    private var canManageStaff: Bool { pharmacistAccess.can(.manageStaff) }
    private var canClosePharmacy: Bool { pharmacistAccess.can(.closePharmacy) }
    private var canJoinAnotherPharmacy: Bool { pharmacistAccess.can(.joinAnotherPharmacy) }
    
    init(
        user: AppUser,
        pharmacistAccess: PharmacistAccess,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService,
        pharmacyId: String
    ) {
        self.user = user
        self.pharmacistAccess = pharmacistAccess
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
        
        let viewModel = PharmacistProfileViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator,
            pharmacyService: pharmacyService
        )
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            Form {
                if canManageStaff { invite }
                
                if canClosePharmacy{ closePharmacy }
                
                if canJoinAnotherPharmacy{ joinAnotherPharmacy }
                
                logout
                
                deleteAccount
            }
            .customNavTitle(user.fullName ?? "")
            .customBackButtonVisibility(false)
            .errorAlert(title: "Failed", loadingState: $vm.loadingState)
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
            .alert("Close Pharmacy?", isPresented: $showingClosePharmacyConfirmation) {
                Button("Close Pharmacy", role: .destructive) {
                    task?.cancel()
                    task = Task {
                        await vm.closePharmacy()
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "Your pharmacy will be permanently closed. This action cannot be undone."
                )
            }
            .customNavigationDestination(for: PharmacistProfileRoute.self) { route in
                switch route {
                case .joinCode:
                    JoinCodeScreen(pharmacyService: pharmacyService, pharmacyId: pharmacyId)
                    
                case .joinAnotherPharmacy:
                    JoinPharmacyScreen(authService: authService, pharmacyService: pharmacyService)
                }
            }
            .onDisappear {
                task?.cancel()
            }
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
    
    private var invite: some View {
        CustomNavValueLink(value: PharmacistProfileRoute.joinCode) {
            Text("Invite a pharmacist?")
        }
    }
    
    private var joinAnotherPharmacy: some View {
        CustomNavValueLink(value: PharmacistProfileRoute.joinAnotherPharmacy) {
            Text("Join another pharmacy")
        }
    }
    
    private var closePharmacy: some View {
        Button("Close pharmacy") {
            showingClosePharmacyConfirmation = true
        }
        .disabled(vm.loadingState.status != .idle)
    }
    
}

enum PharmacistProfileRoute {
    case joinCode
    case joinAnotherPharmacy
}

#Preview {
    PharmacistProfileScreen(
        user: .samples[0],
        pharmacistAccess: .full(role: .owner),
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        pharmacyService: MockPharmacyService.sample,
        pharmacyId: Pharmacy.samples[0].id
    )
}

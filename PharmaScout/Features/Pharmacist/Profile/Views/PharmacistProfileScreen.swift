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
    
    @State private var accountVM: AccountActionsViewModel
    @State private var vm: PharmacistProfileViewModel
    @State private var task: Task<Void, Never>?
    @State private var showingClosePharmacyConfirmation: Bool = false
    
    private var canManageStaff: Bool { pharmacistAccess.can(.manageStaff) }
    private var canClosePharmacy: Bool { pharmacistAccess.can(.closePharmacy) }
    private var canJoinAnotherPharmacy: Bool { pharmacistAccess.can(.joinAnotherPharmacy) }
    
    init(
        user: AppUser,
        pharmacistAccess: PharmacistAccess,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        appleReauthenticationService: AppleReauthenticationService,
        googleReauthenticationService: GoogleReauthenticationService,
        pharmacyService: PharmacyService,
        pharmacyId: String
    ) {
        self.user = user
        self.pharmacistAccess = pharmacistAccess
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
        
        let accountViewModel = AccountActionsViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator,
            appleReauthenticationService: appleReauthenticationService,
            googleReauthenticationService: googleReauthenticationService
        )
        self._accountVM = State(initialValue: accountViewModel)
        
        let viewModel = PharmacistProfileViewModel(pharmacyService: pharmacyService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xLarge) {
                    UserBasicInfoView(user: user)
                        .padding( DesignSystem.Spacing.large)
                        .roundedBackground()
                    
                    pharmacySection
                    
                    AccountSectionView(accountVM: $accountVM)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .customNavTitle(user.fullName ?? "")
            .customNavBarVisibility(.root)
            .scrollBounceBehavior(.basedOnSize)
            .errorAlert(title: "Failed", loadingState: $vm.loadingState)
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
    
    @ViewBuilder
    private var pharmacySection: some View {
        if canManageStaff || canJoinAnotherPharmacy || canClosePharmacy {
            ProfileSectionView(sectionTitle: "Pharmacy") {
                // Invite a pharmacist
                if canManageStaff {
                    CustomNavValueLink(value: PharmacistProfileRoute.joinCode) {
                        ProfileSectionRowView(
                            title: "Invite a pharmacist",
                            description: "Share a join code so a colleague can request to join your pharmacy",
                            systemName: "person.badge.plus.fill",
                        )
                        .disclosureIndicator()
                    }
                }
                
                // Become pharmacy owner
                if canJoinAnotherPharmacy {
                    CustomNavValueLink(value: PharmacistProfileRoute.joinAnotherPharmacy) {
                        ProfileSectionRowView(
                            title: "Join another pharmacy",
                            description: "Work with more than one pharmacy",
                            systemName: "building.2.crop.circle",
                        )
                        .disclosureIndicator()
                    }
                }
                
                // Close pharmacy
                if canClosePharmacy {
                    ProfileSectionRowView(
                        title: "Close pharmacy",
                        systemName: "house.slash",
                        color: .theme.red,
                        isLoading: accountVM.deletionLoadingState.status != .idle
                    )
                    .clickable(isDisabled: vm.loadingState.status != .idle) {
                        showingClosePharmacyConfirmation = true
                    }
                }
            }
        }
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
        appleReauthenticationService: MockAppleAuthService.sample,
        googleReauthenticationService: MockGoogleAuthService.sample,
        pharmacyService: MockPharmacyService.sample,
        pharmacyId: Pharmacy.samples[0].id
    )
}

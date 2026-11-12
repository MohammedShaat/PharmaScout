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
    
    @State private var accountVM: AccountActionsViewModel
    @State private var task: Task<Void, Never>?
    
    init(
        user: AppUser,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        pharmacyService: PharmacyService,
        ownerApplicationService: OwnerApplicationService,
        appleReauthenticationService: AppleReauthenticationService,
        googleReauthenticationService: GoogleReauthenticationService
    ) {
        self.user = user
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.ownerApplicationService = ownerApplicationService
        
        let accountViewModel = AccountActionsViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator,
            appleReauthenticationService: appleReauthenticationService,
            googleReauthenticationService: googleReauthenticationService
        )
        self._accountVM = State(initialValue: accountViewModel)
    }
    
    var body: some View {
        CustomNavStack {
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                UserBasicInfoView(user: user)
                    .padding( DesignSystem.Spacing.large)
                    .roundedBackground()
                
                pharmacySection
                
                AccountSectionView(accountVM: $accountVM)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .customNavBarVisibility(.root)
            .customNavTitle("Profile")
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
    
    private var pharmacySection: some View {
        ProfileSectionView(sectionTitle: "For pharmacies") {
            // Join pharmacy
            CustomNavValueLink(value: ProfileRoute.joinPharmacy) {
                ProfileSectionRowView(
                    title: "Join a pharmacy",
                    description: "Work at an existing pharmacy",
                    systemName: "person.badge.plus.fill",
                )
                .disclosureIndicator()
            }
            
            // Become pharmacy owner
            CustomNavValueLink(value: ProfileRoute.becomePharmacyOwner) {
                ProfileSectionRowView(
                    title: "Become a pharmacy owner",
                    description: "Register a new pharmacy",
                    systemName: "building.2.crop.circle",
                )
                .disclosureIndicator()
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground()
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
        ownerApplicationService: MockOwnerApplicationService.sample,
        appleReauthenticationService: MockAppleAuthService.sample,
        googleReauthenticationService: MockGoogleAuthService.sample
    )
}

//
//  AdminProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct OwnerApplicantProfileScreen: View {
    private let user: AppUser
    private let ownerApplicationService: OwnerApplicationService
    
    @State private var accountVM: AccountActionsViewModel
    @State private var task: Task<Void, Never>?
    
    init(
        user: AppUser,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        appleReauthenticationService: AppleReauthenticationService,
        googleReauthenticationService: GoogleReauthenticationService,
        ownerApplicationService: OwnerApplicationService
    ) {
        self.user = user
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
            .customNavBarVisibility(.root)
            .customNavTitle("Profile")
            .scrollBounceBehavior(.basedOnSize)
            .customNavigationDestination(for: OwnerApplicantProfileRoute.self) { route in
                switch route {
                case .applyAgain:
                    BecomePharmacyOwnerScreen(ownerApplicationService: ownerApplicationService)
                }
            }
        }
    }
    
    private var pharmacySection: some View {
        ProfileSectionView(sectionTitle: "For pharmacies") {
            CustomNavValueLink(value: OwnerApplicantProfileRoute.applyAgain) {
                ProfileSectionRowView(
                    title: "Submit a new application",
                    description: "Enter a new ownership code",
                    systemName: "building.2.crop.circle",
                )
                .disclosureIndicator()
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground()
    }
}

enum OwnerApplicantProfileRoute {
    case applyAgain
}

#Preview {
    OwnerApplicantProfileScreen(
        user: .samples[0],
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        appleReauthenticationService: MockAppleAuthService.sample,
        googleReauthenticationService: MockGoogleAuthService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample
    )
}

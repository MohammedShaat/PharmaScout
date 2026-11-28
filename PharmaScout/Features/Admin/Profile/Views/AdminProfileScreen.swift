//
//  AdminProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct AdminProfileScreen: View {
    let user: AppUser
    
    @State private var accountVM: AccountActionsViewModel
    
    init(
        user: AppUser,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator,
        appleReauthenticationService: AppleReauthenticationService,
        googleReauthenticationService: GoogleReauthenticationService
    ) {
        self.user = user
        
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
                    
                    AccountSectionView(accountVM: $accountVM)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .customNavBarVisibility(.root)
            .customNavTitle("Profile")
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    AdminProfileScreen(
        user: .samples[0],
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample,
        appleReauthenticationService: MockAppleAuthService.sample,
        googleReauthenticationService: MockGoogleAuthService.sample
    )
}

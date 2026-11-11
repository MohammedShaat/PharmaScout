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
    private var showingProvidersSheet: Binding<Bool> {
        Binding {
            vm.availableProviders != nil
        } set: { isPresented in
            if !isPresented { vm.onProviderPicked(nil) }
        }
    }
    private var showingPasswordSheet: Binding<Bool> {
        Binding {
            vm.awaitingPassword
        } set: { isPresented in
            if !isPresented { vm.onPasswordConfirmed(submit: false) }
        }
    }
    
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
        
        let viewModel = ProfileViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator,
            appleReauthenticationService: appleReauthenticationService,
            googleReauthenticationService: googleReauthenticationService
        )
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                UserBasicInfoView(user: user)
                    .padding( DesignSystem.Spacing.large)
                    .roundedBackground()
                
                pharmacySection
                
                sessionSection
                
                DividerView()
                
                deleteAccount
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .customNavBarVisibility(.root)
            .customNavTitle("Profile")
            .errorAlert(title: "Failed", loadingState: vm.logoutLoadingState.error != nil ? $vm.logoutLoadingState : $vm.deletionLoadingState)
            .alert("Delete Account?", isPresented: $showingDeleteAccountConfirmation) {
                Button("Delete Account", role: .destructive) {
                    task?.cancel()
                    task = Task {
                        if let vc = UIApplication.shared.viewController {
                            await vm.deleteAccount(viewController: vc)
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Your account will be permanently deleted. This action cannot be undone.")
            }
            .sheet(isPresented: showingProvidersSheet, onDismiss: { vm.onProviderPicked(nil) }) {
                providersView
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: showingPasswordSheet, onDismiss: { vm.onPasswordConfirmed(submit: false) }) {
                passwordView
                    .presentationDetents([.medium])
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
    
    private var pharmacySection: some View {
        ProfileSectionView(sectionTitle: "For pharmacies") {
            VStack(spacing: DesignSystem.Spacing.medium) {
                // Join pharmacy
                CustomNavValueLink(value: ProfileRoute.joinPharmacy) {
                    ProfileSectionRowView(
                        title: "Join a pharmacy",
                        description: "Work at an existing pharmacy",
                        systemName: "person.badge.plus.fill",
                    )
                    .disclosureIndicator()
                }
                
                DividerView()
                
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
    
    
    private var sessionSection: some View {
        ProfileSectionView(sectionTitle: "Session") {
            ProfileSectionRowView(
                title: "Log out",
                systemName: "rectangle.portrait.and.arrow.right",
                isLoading: vm.logoutLoadingState.status != .idle
            )
            .clickable(isDisabled: vm.isLoading) {
                task?.cancel()
                task = Task {
                    await vm.logout()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.medium)
            .roundedBackground()
        }
    }
    
    private var deleteAccount: some View {
        ProfileSectionRowView(
            title: "Delete account",
            systemName: "trash",
            color: .theme.red,
            isLoading: vm.deletionLoadingState.status != .idle
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground()
        .clickable(isDisabled: vm.isLoading) {
            showingDeleteAccountConfirmation = true
        }
    }
    
    private var providersView: some View {
        AuthProvidersView(
            providers: vm.availableProviders ?? [],
            onContinueInWithGoogleTapped: { vm.onProviderPicked($0) },
            onPasswordTapped: { vm.onProviderPicked($0) },
            onCancelTapped: { vm.onProviderPicked(nil) }
        )
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
        .background(.theme.background)
    }
    
    private var passwordView: some View {
        AuthPasswordView(
            password: $vm.passwordInput,
            isDisabled: !vm.isPasswordValid,
            isLoading: vm.deletionLoadingState.status != .idle && !vm.awaitingPassword,
            onDeleteTapped: { vm.onPasswordConfirmed(submit: true) },
            onCancelTapped: { vm.onPasswordConfirmed(submit: false) }
        )
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
        .background(.theme.background)
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

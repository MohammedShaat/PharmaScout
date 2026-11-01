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
    @State private var isPasswordHidden: Bool = true
    
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
            Form {
                joinPharmacy
                
                becomePharmacyOwner
                
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
                        if let vc = UIApplication.shared.viewController {
                            await vm.deleteAccount(viewController: vc)
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "Your account will be permanently deleted. This action cannot be undone."
                )
            }
            .sheet(
                isPresented: showingProvidersSheet,
                onDismiss: { vm.onProviderPicked(nil) }
            ) {
                providersView
                    .presentationDetents([.medium])
            }
            .sheet(
                isPresented: showingPasswordSheet,
                onDismiss: { vm.onPasswordConfirmed(submit: false) }
            ) {
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
    
    private var providersView: some View {
        VStack {
            ForEach(vm.availableProviders ?? []) { provider in
                switch provider {
                case .google:
                    GoogleSignInButtonView {
                        vm.onProviderPicked(provider)
                    }
                    
                case .email:
                    Button {
                        vm.onProviderPicked(provider)
                    } label: {
                        Text("Password")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                case .apple:
                    EmptyView()
                }
            }
            
            Button("Cancel", role: .cancel) {
                vm.onProviderPicked(nil)
            }
            .padding(.vertical, DesignSystem.Spacing.large)
        }
    }
    
    private var passwordView: some View {
        VStack {
            LabeledSecureFieldView(title: $vm.passwordInput, label: "Account password", isInputHidden: $isPasswordHidden)
            
            HStack {
                PrimaryButtonView(title: "Delete Account", isDisabled: !vm.isPasswordValid) {
                    vm.onPasswordConfirmed(submit: true)
                }
                
                PrimaryButtonView(title: "Cancel") {
                    vm.onPasswordConfirmed(submit: false)
                }
            }
        }
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

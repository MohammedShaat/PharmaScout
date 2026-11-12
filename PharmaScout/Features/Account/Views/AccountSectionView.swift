//
//  AccountSectionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import SwiftUI

struct AccountSectionView: View {
    @Binding var accountVM: AccountActionsViewModel
    
    @State private var showingDeleteAccountConfirmation: Bool = false
    @State private var task: Task<Void, Never>?
    private var showingProvidersSheet: Binding<Bool> {
        Binding {
            accountVM.availableProviders != nil
        } set: { isPresented in
            if !isPresented { accountVM.onProviderPicked(nil) }
        }
    }
    private var showingPasswordSheet: Binding<Bool> {
        Binding {
            accountVM.awaitingPassword
        } set: { isPresented in
            if !isPresented { accountVM.onPasswordConfirmed(submit: false) }
        }
    }
    
    var body: some View {
        Group {
            sessionSection
            
            DividerView()
            
            deleteAccount
        }
        .errorAlert(title: "Failed", loadingState: accountVM.logoutLoadingState.error != nil ? $accountVM.logoutLoadingState : $accountVM.deletionLoadingState)
        .alert("Delete Account?", isPresented: $showingDeleteAccountConfirmation) {
            Button("Delete Account", role: .destructive) {
                task?.cancel()
                task = Task {
                    if let vc = UIApplication.shared.viewController {
                        await accountVM.deleteAccount(viewController: vc)
                    }
                }
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your account will be permanently deleted. This action cannot be undone.")
        }
        .sheet(isPresented: showingProvidersSheet, onDismiss: { accountVM.onProviderPicked(nil) }) {
            providersView
                .presentationDetents([.medium])
        }
        .sheet(isPresented: showingPasswordSheet, onDismiss: { accountVM.onPasswordConfirmed(submit: false) }) {
            passwordView
                .presentationDetents([.medium])
        }
        .onDisappear {
            task?.cancel()
        }
    }
    
    private var sessionSection: some View {
        ProfileSectionView(sectionTitle: "Session") {
            ProfileSectionRowView(
                title: "Log out",
                systemName: "rectangle.portrait.and.arrow.right",
                isLoading: accountVM.logoutLoadingState.status != .idle
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .clickable(isDisabled: accountVM.isLoading) {
                task?.cancel()
                task = Task {
                    await accountVM.logout()
                }
            }
        }
    }
    
    private var deleteAccount: some View {
        ProfileSectionRowView(
            title: "Delete account",
            systemName: "trash",
            color: .theme.red,
            isLoading: accountVM.deletionLoadingState.status != .idle
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground()
        .clickable(isDisabled: accountVM.isLoading) {
            showingDeleteAccountConfirmation = true
        }
    }
    
    private var providersView: some View {
        AuthProvidersView(
            providers: accountVM.availableProviders ?? [],
            onContinueInWithGoogleTapped: { accountVM.onProviderPicked($0) },
            onPasswordTapped: { accountVM.onProviderPicked($0) },
            onCancelTapped: { accountVM.onProviderPicked(nil) }
        )
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
        .background(.theme.background)
    }
    
    private var passwordView: some View {
        AuthPasswordView(
            password: $accountVM.passwordInput,
            isDisabled: !accountVM.isPasswordValid,
            isLoading: accountVM.deletionLoadingState.status != .idle && !accountVM.awaitingPassword,
            onDeleteTapped: { accountVM.onPasswordConfirmed(submit: true) },
            onCancelTapped: { accountVM.onPasswordConfirmed(submit: false) }
        )
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
        .background(.theme.background)
    }
}

#Preview {
//    AccountSectionView(accountVM: <#Binding<AccountActionsViewModel>#>)
}

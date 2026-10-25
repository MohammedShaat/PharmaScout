//
//  AdminProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct AdminProfileScreen: View {
    let user: AppUser
    let authService: AuthService
    
    @State private var vm: AdminProfileViewModel
    @State private var task: Task<Void, Never>?
    
    init(
        user: AppUser,
        authService: AuthService,
        pushTokenCoordinator: PushTokenCoordinator
    ) {
        self.user = user
        self.authService = authService
        
        let viewModel = AdminProfileViewModel(
            authService: authService,
            pushTokenCoordinator: pushTokenCoordinator
        )
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            Form {
                logout
            }
            .customNavTitle(user.fullName ?? "")
            .customBackButtonVisibility(false)
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    private var logout: some View {
        LogOutButtonView(isLoading: vm.logoutLoadingState.status != .idle) {
            task?.cancel()
            task = Task {
                await vm.logout()
            }
        }
    }
}

#Preview {
    AdminProfileScreen(
        user: .samples[0],
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample
    )
}

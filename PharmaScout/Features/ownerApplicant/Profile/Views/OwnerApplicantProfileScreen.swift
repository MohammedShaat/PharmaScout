//
//  AdminProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct OwnerApplicantProfileScreen: View {
    let authService: AuthService
    
    @State private var vm: OwnerApplicantProfileViewModel
    @State private var task: Task<Void, Never>?
    
    init(authService: AuthService, pushTokenCoordinator: PushTokenCoordinator) {
        self.authService = authService
        
        let viewModel = OwnerApplicantProfileViewModel(
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
            .customBackButtonVisibility(false)
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    private var logout: some View {
        Button {
            task?.cancel()
            task = Task {
                await vm.logout()
            }
        } label: {
            HStack {
                Text("Log out")
                
                if vm.logoutLoadingState.status != .idle {
                    RingProgressView()
                }
            }
        }
        .disabled(vm.logoutLoadingState.status != .idle)
    }
}

#Preview {
    OwnerApplicantProfileScreen(
        authService: MockAuthService.sample,
        pushTokenCoordinator: .sample
    )
}

//
//  ProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct ProfileScreen: View {
    let authService: AuthService
    @State private var vm: ProfileViewModel
    
    init(authService: AuthService) {
        self.authService = authService
        let viewModel = ProfileViewModel(authService: authService)
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        Form {
            Button("Log out") {
                Task {
                    try? await authService.signOut()
                }
            }
        }
    }
}

#Preview {
    ProfileScreen(authService: MockAuthService.sample)
}

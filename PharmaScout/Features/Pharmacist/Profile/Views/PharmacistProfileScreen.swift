//
//  PharmacistProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistProfileScreen: View {
    let authService: AuthService
    @State private var vm: PharmacistProfileViewModel
    
    init(authService: AuthService) {
        self.authService = authService
        let viewModel = PharmacistProfileViewModel(authService: authService)
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
    PharmacistProfileScreen(authService: MockAuthService.sample)
}

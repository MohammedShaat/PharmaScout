//
//  ProfileScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct ProfileScreen: View {
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    @State private var vm: ProfileViewModel
    
    init(authService: AuthService, pharmacyService: PharmacyService) {
        self.authService = authService
        self.pharmacyService = pharmacyService
        let viewModel = ProfileViewModel(authService: authService)
        self._vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            Form {
                if vm.canJoinPharmacy {
                    CustomNavValueLink(value: ProfileRoute.joinPharmacy) {
                        Text("Join a pharmacy")
                    }
                }
                
                Button("Log out") {
                    Task {
                        try? await authService.signOut()
                    }
                }
            }
            .customBackButtonVisibility(false)
            .customNavigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .joinPharmacy:
                    JoinPharmacyScreen(authService: authService, pharmacyService: pharmacyService)
                }
            }
        }
    }
}

enum ProfileRoute {
    case joinPharmacy
}

#Preview {
    ProfileScreen(
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

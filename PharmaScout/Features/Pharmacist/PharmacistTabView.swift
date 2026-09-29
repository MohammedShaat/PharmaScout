//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistTabView: View {
    private let authService: AuthService
    
    @State private var vm = PharmacistTabViewModel()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                PharmacistHomeScreen()
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                PharmacistProfileScreen(authService: authService)
            }
        }
    }
    
    private func tabImage(_ tab: PharmacistTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "homeSelected" : "home"
        case .inquiries:
            isSelected(tab) ? "" : ""
        case .pharmacy:
            isSelected(tab) ? "" : ""
        case .analytics:
            isSelected(tab) ? "" : ""
        case .profile:
            isSelected(tab) ? "profileSelected" : "profile"
        }
    }
    
    private func isSelected(_ tab: PharmacistTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    PharmacistTabView(authService: MockAuthService.sample)
}

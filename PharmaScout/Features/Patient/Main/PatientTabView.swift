//
//  PatientTabView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct PatientTabView: View {
    let authService: AuthService
    @State private var vm = PatientTabViewModel()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                HomeScreen(authService: authService)
            }
            
            
            Tab("Recent", image: tabImage(.recent), value: .recent) {
                
            }
            
            Tab("Pharmacies", image: tabImage(.pharmacies), value: .pharmacies) {
                
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                ProfileScreen(authService: authService)
            }
        }
        .tint(.theme.textPrimary)	
        
    }
    
    private func tabImage(_ tab: PatientTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "homeSelected" : "home"
        case .recent:
            isSelected(tab) ? "historySelected" : "history"
        case .pharmacies:
            isSelected(tab) ? "locationPlusSelected" : "locationPlus"
        case .profile:
            isSelected(tab) ? "profileSelected" : "profile"
        }
    }
    
    private func isSelected(_ tab: PatientTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    PatientTabView(authService: MockAuthService.sample)
}

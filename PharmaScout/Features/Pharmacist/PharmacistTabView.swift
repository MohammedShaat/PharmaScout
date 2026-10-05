//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistTabView: View {
    private let authService: AuthService
    private let inquiryService: InquiryService
    private let drugService: DrugService
    private let pharmacyService: PharmacyService
    
    @State private var vm: PharmacistTabViewModel
    
    init(
        authService: AuthService,
        inquiryService: InquiryService,
        drugService: DrugService,
        pharmacyService: PharmacyService
    ) {
        self.authService = authService
        self.inquiryService = inquiryService
        self.drugService = drugService
        self.pharmacyService = pharmacyService
        
        let viewModel = PharmacistTabViewModel(authService: authService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                PharmacistHomeScreen(pharmacistTabViewModel: vm, authService: authService, inquiryService: inquiryService)
            }
            
            if vm.isAuthorized {
                Tab("Inquiries", image: tabImage(.inquiries), value: .inquiries) {
                    InquiriesScreen(path: $vm.inquiriesPath, authService: authService, inquiryService: inquiryService, drugService: drugService)
                }
                
                Tab("Pharmacy", image: tabImage(.pharmacy), value: .pharmacy) {
                    PharmacyScreen(authService: authService, pharmacyService: pharmacyService)
                }
                
                Tab("Analytics", image: tabImage(.analytics), value: .analytics) {
                    
                }
            }
            
            Tab("Profile", image: tabImage(.profile), value: .profile) {
                PharmacistProfileScreen(authService: authService)
            }
        }
        .tint(.theme.primary)
    }
    
    private func tabImage(_ tab: PharmacistTab) -> String {
        switch tab {
        case .home:
            isSelected(tab) ? "home-fill" : "home"
        case .inquiries:
            isSelected(tab) ? "send-beaker-fill" : "send-beaker"
        case .pharmacy:
            isSelected(tab) ? "pharmacy-fill" : "pharmacy"
        case .analytics:
            isSelected(tab) ? "analytics-fill" : "analytics"
        case .profile:
            isSelected(tab) ? "profile-fill" : "profile"
        }
    }
    
    private func isSelected(_ tab: PharmacistTab) -> Bool {
        vm.selectedTab == tab
    }
}

#Preview {
    PharmacistTabView(
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample,
        drugService: MockDrugService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

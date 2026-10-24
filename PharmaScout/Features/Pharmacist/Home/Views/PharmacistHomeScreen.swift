//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistHomeScreen: View {
    private let pharmacistTabViewModel: PharmacistTabViewModel
    private let staffMembership: StaffMembership
    private let inquiryService: InquiryService
    private let authService: AuthService
    
    init(
        pharmacistTabViewModel: PharmacistTabViewModel,
        staffMembership: StaffMembership,
        inquiryService: InquiryService,
        authService: AuthService
    ) {
        self.pharmacistTabViewModel = pharmacistTabViewModel
        self.staffMembership = staffMembership
        self.inquiryService = inquiryService
        self.authService = authService
    }
    
    var body: some View {
        switch pharmacistTabViewModel.access {
        case .full:
            PharmacistDashboardScreen(
                pharmacistTabViewModel: pharmacistTabViewModel,
                staffMembership: staffMembership,
                inquiryService: inquiryService,
                authService: authService
            )
            
        case .restricted(let role, let restriction):
            PharmacistRestrictedHomeScreen(
                authService: authService,
                role: role,
                pharmacistRestriction: restriction
            )
        }
    }
}

#Preview {
    PharmacistHomeScreen(
        pharmacistTabViewModel: .sample,
        staffMembership: .samples[0],
        inquiryService: MockInquiryService.sample,
        authService: MockAuthService.sample,
    )
}

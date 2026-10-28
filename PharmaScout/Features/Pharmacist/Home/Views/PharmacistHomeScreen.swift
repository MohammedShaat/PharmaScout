//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistHomeScreen: View {
    private let user: AppUser
    private let pharmacistTabViewModel: PharmacistTabViewModel
    private let staffMembership: StaffMembership
    private let inquiryService: InquiryService
    
    init(
        user: AppUser,
        pharmacistTabViewModel: PharmacistTabViewModel,
        staffMembership: StaffMembership,
        inquiryService: InquiryService,
    ) {
        self.user = user
        self.pharmacistTabViewModel = pharmacistTabViewModel
        self.staffMembership = staffMembership
        self.inquiryService = inquiryService
    }
    
    var body: some View {
        switch pharmacistTabViewModel.access {
        case .full:
            PharmacistDashboardScreen(
                user: user,
                pharmacistTabViewModel: pharmacistTabViewModel,
                staffMembership: staffMembership,
                inquiryService: inquiryService,
            )
            
        case .restricted(let role, let restriction):
            PharmacistRestrictedHomeScreen(
                user: user,
                role: role,
                pharmacistRestriction: restriction
            )
        }
    }
}

#Preview {
    PharmacistHomeScreen(
        user: AppUser.samples[0],
        pharmacistTabViewModel: .sample,
        staffMembership: .samples[0],
        inquiryService: MockInquiryService.sample,
    )
}

//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistTabView: View {
    private let user: AppUser
    private let router: AppRouter
    private let staffMembership: StaffMembership
    let dependencies: AppDependencies
    
    @State private var vm: PharmacistTabViewModel
    
    init(
        user: AppUser,
        router: AppRouter,
        staffMembership: StaffMembership,
        dependencies: AppDependencies
    ) {
        self.user = user
        self.router = router
        self.staffMembership = staffMembership
        self.dependencies = dependencies
        
        let viewModel = PharmacistTabViewModel(staffMembership: staffMembership)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                PharmacistHomeScreen(user: user, pharmacistTabViewModel: vm, staffMembership: staffMembership, inquiryService: dependencies.inquiryService)
            }
            
            if vm.access.canAccess(.inquiries) {
                Tab("Inquiries", image: tabImage(.inquiries), value: .inquiries) {
                    InquiriesScreen(path: $vm.inquiriesPath, staffMembership: staffMembership, authService: dependencies.authService, inquiryService: dependencies.inquiryService, drugService: dependencies.drugService)
                }
            }
            
            if vm.access.canAccess(.pharmacy) {
                Tab("Pharmacy", image: tabImage(.pharmacy), value: .pharmacy) {
                    PharmacyScreen(path: $vm.pharmacyPath, userId: user.id, pharmacyId: staffMembership.pharmacyId, pharmacistAccess: vm.access, pharmacyService: dependencies.pharmacyService)
                }
            }
            
            if vm.access.canAccess(.analytics) {
                Tab("Analytics", image: tabImage(.analytics), value: .analytics) {
                    AnalyticsScreen(pharmacyId: staffMembership.pharmacyId, analyticsService: dependencies.analyticsService)
                }
            }
            
            if vm.access.canAccess(.profile) {
                Tab("Profile", image: tabImage(.profile), value: .profile) {
                    PharmacistProfileScreen(user: user, pharmacistAccess: vm.access, authService: dependencies.authService, pushTokenCoordinator: dependencies.pushTokenCoordinator, appleReauthenticationService: dependencies.appleReauthenticationService, googleReauthenticationService: dependencies.googleReauthenticationService, pharmacyService: dependencies.pharmacyService, pharmacyId: staffMembership.pharmacyId)
                }
            }
        }
        .tint(.theme.primary)
        .onChange(of: router.pendingNotificationRoute, initial: true) { oldValue, newValue in
            guard let route = router.consumePendingPharmacistNotificationRoute() else { return }
            vm.handle(route)
        }
        .onChange(of: staffMembership) {
            vm.onStaffMembershipChanged(staffMembership)
        }
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
        user: .samples[0],
        router: .sample,
        staffMembership: .samples[0],
        dependencies: .uiTesting()
    )
}

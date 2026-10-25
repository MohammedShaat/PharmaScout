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
    private let authService: AuthService
    private let inquiryService: InquiryService
    private let drugService: DrugService
    private let pharmacyService: PharmacyService
    private let analyticsService: AnalyticsService
    private let pushTokenCoordinator: PushTokenCoordinator
    
    @State private var vm: PharmacistTabViewModel
    
    init(
        user: AppUser,
        router: AppRouter,
        staffMembership: StaffMembership,
        authService: AuthService,
        inquiryService: InquiryService,
    drugService: DrugService,
        pharmacyService: PharmacyService,
        analyticsService: AnalyticsService,
        pushTokenCoordinator: PushTokenCoordinator
    ) {
        self.user = user
        self.router = router
        self.staffMembership = staffMembership
        self.authService = authService
        self.inquiryService = inquiryService
        self.drugService = drugService
        self.pharmacyService = pharmacyService
        self.analyticsService = analyticsService
        self.pushTokenCoordinator = pushTokenCoordinator
        
        let viewModel = PharmacistTabViewModel(staffMembership: staffMembership)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Home", image: tabImage(.home), value: .home) {
                PharmacistHomeScreen(pharmacistTabViewModel: vm, staffMembership: staffMembership, inquiryService: inquiryService, authService: authService)
            }
            
            if vm.access.canAccess(.inquiries) {
                Tab("Inquiries", image: tabImage(.inquiries), value: .inquiries) {
                    InquiriesScreen(path: $vm.inquiriesPath, staffMembership: staffMembership, authService: authService, inquiryService: inquiryService, drugService: drugService)
                }
            }
            
            if vm.access.canAccess(.pharmacy) {
                Tab("Pharmacy", image: tabImage(.pharmacy), value: .pharmacy) {
                    PharmacyScreen(pharmacyId: staffMembership.pharmacyId, pharmacistAccess: vm.access, authService: authService, pharmacyService: pharmacyService)
                }
            }
            
            if vm.access.canAccess(.analytics) {
                Tab("Analytics", image: tabImage(.analytics), value: .analytics) {
                    AnalyticsScreen(pharmacyId: staffMembership.pharmacyId, analyticsService: analyticsService)
                }
            }
            
            if vm.access.canAccess(.profile) {
                Tab("Profile", image: tabImage(.profile), value: .profile) {
                    PharmacistProfileScreen(user: user, pharmacistAccess: vm.access, authService: authService, pushTokenCoordinator: pushTokenCoordinator, pharmacyService: pharmacyService, pharmacyId: staffMembership.pharmacyId)
                }
            }
        }
        .tint(.theme.primary)
        .onChange(of: router.pendingNotificationRoute, initial: true) { oldValue, newValue in
            guard let route = router.consumePendingPharmacistNotificationRoute() else { return }
            vm.handle(route)
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
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample,
        drugService: MockDrugService.sample,
        pharmacyService: MockPharmacyService.sample,
        analyticsService: MockAnalyticsService.sample,
        pushTokenCoordinator: .sample
    )
}

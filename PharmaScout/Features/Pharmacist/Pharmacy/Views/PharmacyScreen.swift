//
//  PharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyScreen: View {
    private let pharmacyService: PharmacyService
    
    @State private var vm: PharmacyViewModel
    @State private var path = NavigationPath()
    
    init(
        authService: AuthService,
        pharmacyService: PharmacyService
    ) {
        self.pharmacyService = pharmacyService
        
        let viewModel = PharmacyViewModel(
            authService: authService,
            pharmacyService: pharmacyService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: $path) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    pharmacySection
                    
                    contactSection
                    
                    workingHoursSection
                    
                    staffSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customBackButtonVisibility(false)
            .customNavTitle(vm.pharmacy?.name ?? "")
            .customNavigationDestination(for: PharmacyRoute.self) { route in
                switch route {
                case .editAddress:
                    if let pharmacy = vm.pharmacy {
                        PharmacyEditAddressScreen(pharmacyService: pharmacyService, pharmacy: pharmacy)
                    }
                }
            }
            .refreshable(action: vm.refresh)
            .onAppear {
                vm.loadDataIfNeeded()
            }
        }
    }
    
    private var pharmacySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Pharmacy Info") {
                path.append(PharmacyRoute.editAddress)
            }
            
            LoadingContentView(
                LoadingState: vm.pharmacyLoadingState,
                isEmpty: vm.pharmacy == nil,
                emptyMessage: "No pharmacy info") {
                    if let pharmacy = vm.pharmacy {
                        PharmacyAddressAndDistanceView(pharmacy: pharmacy)
                    }
                }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Contact")
            
            PharmacyContactView(contacts: vm.contacts, loadingState: vm.contactLoadingState)
        }
    }
    
    private var workingHoursSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Working Hours")
            
            PharmacyWorkingHoursView(workingHours: vm.workingHours, loadingState: vm.workingHoursLoadingState)
        }
    }
    
    private var staffSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Staff")
            
            LoadingContentView(
                LoadingState: vm.staffLoadingState,
                isEmpty: vm.pharmacyStaff.isEmpty,
                emptyMessage: "There is no staff") {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        ForEach(vm.pharmacyStaff) { member in
                            PharmacyStaffMemeberView(member: member)
                        }
                    }
                }
        }
    }
}

enum PharmacyRoute {
    case editAddress
}

#Preview {
    PharmacyScreen(
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

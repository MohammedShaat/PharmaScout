//
//  PharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyScreen: View {
    @State private var vm: PharmacyViewModel
    
    init(authService: AuthService, pharmacyService: PharmacyService) {
        let viewModel = PharmacyViewModel(
            authService: authService,
            pharmacyService: pharmacyService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                pharmacySection
                
                PharmacyContactView(contacts: vm.contacts, loadingState: vm.contactLoadingState)
                
                PharmacyWorkingHoursView(workingHours: vm.workingHours, loadingState: vm.workingHoursLoadingState)
                
                staffSection
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavTitle(vm.pharmacy?.name ?? "")
        .refreshable(action: vm.refresh)
        .onAppear {
            vm.loadDataIfNeeded()
        }
    }
    
    private var pharmacySection: some View {
        LoadingContentView(
            LoadingState: vm.pharmacyLoadingState,
            isEmpty: vm.pharmacy == nil,
            emptyMessage: "No pharmacy info") {
                if let pharmacy = vm.pharmacy {
                    PharmacyAddressAndDistanceView(pharmacy: pharmacy)
                }
            }
    }
    
    private var staffSection: some View {
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

#Preview {
    PharmacyScreen(
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

//
//  PharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyScreen: View {
    private let pharmacistAccess: PharmacistAccess
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    
    @State private var vm: PharmacyViewModel
    @State private var path = NavigationPath()
    
    private var canEditPharmacy: Bool { pharmacistAccess.can(.editPharmacy) }
    private var canEditStaff: Bool { pharmacistAccess.can(.manageStaff) }
    
    init(
        pharmacyId: String,
        pharmacistAccess: PharmacistAccess,
        authService: AuthService,
        pharmacyService: PharmacyService
    ) {
        self.pharmacistAccess = pharmacistAccess
        self.authService = authService
        self.pharmacyService = pharmacyService
        
        let viewModel = PharmacyViewModel(
            pharmacyId: pharmacyId,
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
                if let pharmacy = vm.pharmacy {
                    switch route {
                    case .editAddress:
                        PharmacyEditAddressScreen(pharmacyService: pharmacyService, pharmacy: pharmacy)
                        
                    case .editContact:
                        PharmacyEditContactScreen(pharmacyService: pharmacyService, pharmacy: pharmacy, contacts: vm.contacts)
                        
                    case .editWorkingHours:
                        PharmacyEditWorkingHourScreen(pharmacyService: pharmacyService, pharmacy: pharmacy, workingHours: vm.workingHours)
                        
                    case .editStaff:
                        PharmacyEditStaffScreen(authService: authService, pharmacyService: pharmacyService, pharmacy: pharmacy, staffMembers: vm.pharmacyStaff)
                    }
                }
            }
            .refreshable(action: vm.refresh)
            .onAppear(perform: vm.loadDataIfNeeded)
            .task(vm.listenToPharmacyChanges)
            .task(vm.listenToContactChanges)
            .task(vm.listenToWokringHoursChanges)
            .task(vm.listenToStaffChanges)
        }
    }
    
    private var pharmacySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Pharmacy Info", isActionDisabled: !canEditPharmacy) {
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
            EditSectionHeaderView(title: "Contact", isActionDisabled: !canEditPharmacy) {
                path.append(PharmacyRoute.editContact)
            }
            
            LoadingContentView(
                LoadingState: vm.contactLoadingState,
                isEmpty: vm.contacts.isEmpty,
                emptyMessage: "There is no contact info"
            ) {
                PharmacyContactView(contacts: vm.contacts)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var workingHoursSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Working Hours", isActionDisabled: !canEditPharmacy) {
                path.append(PharmacyRoute.editWorkingHours)
            }
            
            LoadingContentView(
                LoadingState: vm.workingHoursLoadingState,
                isEmpty: vm.workingHours.isEmpty,
                emptyMessage: "There is no working hours info"
            ) {
                PharmacyWorkingHoursView(workingHours: vm.workingHours)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var staffSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Staff", isActionDisabled: !canEditStaff) {
                path.append(PharmacyRoute.editStaff)
            }
            
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
    case editContact
    case editWorkingHours
    case editStaff
}

#Preview {
    PharmacyScreen(
        pharmacyId: Pharmacy.samples[0].id,
        pharmacistAccess: .full(role: .owner),
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

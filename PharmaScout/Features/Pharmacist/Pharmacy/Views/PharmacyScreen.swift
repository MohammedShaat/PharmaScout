//
//  PharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyScreen: View {
    private let userId: String
    private let pharmacistAccess: PharmacistAccess
    private let pharmacyService: PharmacyService
    
    @State private var vm: PharmacyViewModel
    @State private var path = NavigationPath()
    
    private var canEditPharmacy: Bool { pharmacistAccess.can(.editPharmacy) }
    private var canEditStaff: Bool { pharmacistAccess.can(.manageStaff) }
    
    init(
        userId: String,
        pharmacyId: String,
        pharmacistAccess: PharmacistAccess,
        pharmacyService: PharmacyService
    ) {
        self.userId = userId
        self.pharmacistAccess = pharmacistAccess
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
                    pharmacyBasicInfoSection
                    
                    contactSection
                    
                    workingHoursSection
                    
                    if canEditStaff {
                        staffSection
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(.root)
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
                        PharmacyEditStaffScreen(userId: userId, pharmacyService: pharmacyService, pharmacy: pharmacy, staffMembers: vm.pharmacyStaff)
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
    
    private var pharmacyBasicInfoSection: some View {
        EditSectionHeaderView(
            title: "Pharmacy Info",
            showAction: canEditPharmacy,
            onActionTapped: { path.append(PharmacyRoute.editAddress) }
        ) {
            LoadingContentView(
                loadingState: vm.pharmacyLoadingState,
                showMessage: vm.pharmacy == nil,
                emptyTitle: "Pharmacy not found",
                emptyMessage: "This pharmacy may have been removed or is no longer available.",
                errorTitle: "Couldn't load the pharmacy info"
            ) {
                if let pharmacy = vm.pharmacy {
                    PharmacyBasicInfoView(pharmac: pharmacy, showSeeLocation: false)
                        .frame(maxWidth: .infinity)
                        .padding(.top, DesignSystem.Spacing.large)
                        .roundedBackground()
                }
            }
        }
        .frame(minHeight: vm.pharmacyLoadingState.status != .idle ? 300 : 0, alignment: .top)
    }
    
    private var contactSection: some View {
        EditSectionHeaderView(
            title: "Contact",
            showAction: canEditPharmacy,
            onActionTapped: { path.append(PharmacyRoute.editContact) }
        ) {
            LoadingContentView(
                loadingState: vm.contactLoadingState,
                showMessage: vm.contacts.isEmpty,
                emptyTitle: "No contact information",
                emptyMessage: "No contact details have been added yet.",
                errorTitle: "Couldn't load contact information",
                showIcon: false
            ) {
                CustomList(items: vm.contacts, isLoadingMore: false) { contact in
                    PharmacyContactView(contact: contact)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(minHeight: vm.contactLoadingState.status != .idle ? 250 : 0, alignment: .top)
    }
    
    private var workingHoursSection: some View {
        EditSectionHeaderView(
            title: "Working Hours",
            showAction: canEditPharmacy,
            onActionTapped: { path.append(PharmacyRoute.editWorkingHours) }
        ) {
            LoadingContentView(
                loadingState: vm.workingHoursLoadingState,
                showMessage: vm.workingHours.isEmpty,
                emptyTitle: "No working hours",
                emptyMessage: "No working hours have been added yet.",
                errorTitle: "Couldn't load working hours"
            ) {
                WorkingHourListView(workingHours: vm.workingHours)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(minHeight: vm.workingHoursLoadingState.status != .idle ? 250 : 0, alignment: .top)
    }
    
    private var staffSection: some View {
        EditSectionHeaderView(
            title: "Staff",
            showAction: canEditStaff,
            onActionTapped: { path.append(PharmacyRoute.editStaff) }
        ) {
            LoadingContentView(
                loadingState: vm.staffLoadingState,
                showMessage: vm.pharmacyStaff.isEmpty,
                emptyTitle: "No staff members",
                emptyMessage: "No staff members have been added to this pharmacy yet.",
                errorTitle: "Couldn't load staff"
            ) {
                CustomList(items: vm.pharmacyStaff, isLoadingMore: false,) { member in
                    PharmacyStaffMemeberView(member: member, isCurrentUser: userId == member.userInfo.id)
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
        userId: AppUser.samples[0].id,
        pharmacyId: Pharmacy.samples[0].id,
        pharmacistAccess: .full(role: .owner),
        pharmacyService: MockPharmacyService.sample
    )
}

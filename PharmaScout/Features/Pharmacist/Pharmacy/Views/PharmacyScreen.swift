//
//  PharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyScreen: View {
    private let userId: String
    private let pharmacyId: String
    private let pharmacistAccess: PharmacistAccess
    private let pharmacyService: PharmacyService
    
    @State private var vm: PharmacyViewModel
    @Binding var path: NavigationPath
    
    private var canEditPharmacy: Bool { pharmacistAccess.can(.editPharmacy) }
    private var canEditStaff: Bool { pharmacistAccess.can(.manageStaff) }
    
    init(
        path: Binding<NavigationPath>,
        userId: String,
        pharmacyId: String,
        pharmacistAccess: PharmacistAccess,
        pharmacyService: PharmacyService
    ) {
        self._path = path
        self.userId = userId
        self.pharmacyId = pharmacyId
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
                if case .editStaff(let pharmacyId, let staff) = route {
                    PharmacyEditStaffScreen(userId: userId, pharmacyService: pharmacyService, pharmacyId: pharmacyId, staffMembers: staff)
                }
                else if let pharmacy = vm.pharmacy {
                    switch route {
                    case .editAddress:
                        PharmacyEditAddressScreen(pharmacyService: pharmacyService, pharmacy: pharmacy)
                        
                    case .editContact:
                        PharmacyEditContactScreen(pharmacyService: pharmacyService, pharmacy: pharmacy, contacts: vm.contacts)
                        
                    case .editWorkingHours:
                        PharmacyEditWorkingHourScreen(pharmacyService: pharmacyService, pharmacy: pharmacy, workingHours: vm.workingHours)
                        
                    case .editStaff:
                        EmptyView() // Already handled above
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
        .frame(minHeight: vm.pharmacyLoadingState.status == .loading ? 300 : 0, alignment: .top)
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
        .frame(minHeight: vm.contactLoadingState.status == .loading ? 250 : 0, alignment: .top)
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
        .frame(minHeight: vm.workingHoursLoadingState.status == .loading ? 250 : 0, alignment: .top)
    }
    
    private var staffSection: some View {
        EditSectionHeaderView(
            title: "Staff",
            showAction: canEditStaff,
            onActionTapped: {
                path.append(PharmacyRoute.editStaff(pharmacyId: pharmacyId, staff: vm.pharmacyStaff))
            }
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

enum PharmacyRoute: Hashable {
    case editAddress
    case editContact
    case editWorkingHours
    case editStaff(pharmacyId: String, staff: [PharmacyStaffMember]?)
    
}

#Preview {
    @State @Previewable var path = NavigationPath()
    
    PharmacyScreen(
        path: $path,
        userId: AppUser.samples[0].id,
        pharmacyId: Pharmacy.samples[0].id,
        pharmacistAccess: .full(role: .owner),
        pharmacyService: MockPharmacyService.sample
    )
}

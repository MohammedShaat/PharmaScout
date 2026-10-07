//
//  PharmacyEditStaffScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import SwiftUI
import Swipy

struct PharmacyEditStaffScreen: View {
    @State private var vm: PharmacyEditStaffViewModel
    @State private var updateTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(
        authService: AuthService,
        pharmacyService: PharmacyService,
        pharmacy: Pharmacy,
        staffMembers: [PharmacyStaffMember]
    ) {
        let viewModel = PharmacyEditStaffViewModel(
            authService: authService,
            pharmacyService: pharmacyService,
            pharmacy: pharmacy,
            staffMembers: staffMembers
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            staffMemberListSection
            
            addNewStaffMemberSection
            
            errorSection
            
            buttonSection
        }
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .onDisappear {
            updateTask?.cancel()
        }
    }
    
    private var staffMemberListSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            ForEach($vm.staffMembers) { $staffMember in
                Swipy(
                    isSwipingAnItem: $isSwipingAnItem,
                    swipeActionsMargin: SwipyHorizontalMargin(
                        leading: DesignSystem.Spacing.xSmall,
                        trailing: DesignSystem.Spacing.xSmall
                    ),
                    swipeBehavior: .straight
                ) { model in
                    contactItemView($staffMember)
                    
                } actions: {
                    SwipyAction { model in
                        Button(role: .destructive) {
                            vm.deleteStaffMember(staffMember)
                            model.unswipe()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    private var addNewStaffMemberSection: some View {
        Text("Add member")
            .foregroundStyle(.theme.textPrimary)
            .padding(.vertical, DesignSystem.Spacing.small)
            .clickable(action: vm.addStaffMember)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = vm.loadingState.error {
            Text(error.errorDescription)
        }
    }
    
    private func contactItemView(_ staffMember: Binding<PharmacyStaffMember>) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
            HStack {
                Text(staffMember.wrappedValue.userInfo.fullName ?? "")
                Text(staffMember.wrappedValue.userInfo.email ?? "")
            }
            
            HStack {
                HStack {
                    Text("Role")
                    
                    Picker("Role", selection: staffMember.role) {
                        ForEach(PharmacyStaffRole.allCases, id: \.self) { role in
                            Text(role.rawValue.capitalized)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    Text("Status")
                    
                    Picker("Status", selection: staffMember.status) {
                        ForEach(PharmacyStaffStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonSection: some View {
        PrimaryButtonView(
            title: "Save",
            isDisabled: !vm.canUpdate,
            isLoading: vm.loadingState.status != .idle) {
                updateTask?.cancel()
                updateTask = Task {
                    await vm.updateStaff {
                        dismiss()
                    }
                }
            }
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let staffMembers = PharmacyStaffMember.samples.filter { $0.pharmacyId == pharmacy.id }
    
    PharmacyEditStaffScreen(
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample,
        pharmacy: pharmacy,
        staffMembers: staffMembers
    )
}

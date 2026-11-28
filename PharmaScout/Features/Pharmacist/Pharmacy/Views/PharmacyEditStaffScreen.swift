//
//  PharmacyEditStaffScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import SwiftUI
import Swipy

struct PharmacyEditStaffScreen: View {
    let userId: String
    
    @State private var vm: PharmacyEditStaffViewModel
    @State private var updateTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(
        userId: String,
        pharmacyService: PharmacyService,
        pharmacyId: String,
        staffMembers: [PharmacyStaffMember]?
    ) {
        self.userId = userId
        
        let viewModel = PharmacyEditStaffViewModel(
            userId: userId,
            pharmacyService: pharmacyService,
            pharmacyId: pharmacyId,
            staffMembers: staffMembers
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    SwipeHintView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    staffMemberListSection
                }
            }
        }
        .customNavTitle("Staff")
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .errorAlert(title: "Couldn't update the staff", loadingState: $vm.updateLoadingState)
        .onAppear {
            vm.loadDataIfNeeded()
        }
        .onDisappear {
            updateTask?.cancel()
        }
        .task(vm.listenToStaffChanges)
    }
    
    private var staffMemberListSection: some View {
        LoadingContentView(
            loadingState: vm.staffLoadingState,
            showMessage: vm.staffMembers?.isEmpty ?? true,
            emptyTitle: "No staff members",
            emptyMessage: "Staff members added to this pharmacy will appear here.",
            errorTitle: "Couldn't load staff members"
        ) {
            if let staffMembers = vm.staffMembers {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    ForEach(staffMembers) { staffMember in
                        if userId == staffMember.userInfo.id {
                            staffMemberItemView(staffMember)
                            
                        } else {
                            Swipy(
                                isSwipingAnItem: $isSwipingAnItem,
                                swipeActionsMargin: SwipyHorizontalMargin(
                                    leading: DesignSystem.Spacing.xSmall,
                                    trailing: DesignSystem.Spacing.xSmall
                                ),
                                swipeBehavior: .straight
                            ) { model in
                                staffMemberItemView(staffMember)
                                
                            } actions: {
                                SwipyAction { model in
                                    Button(role: .destructive) {
                                        updateMember(memberId: staffMember.id, action: .delete) {
                                            model.unswipe()
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func staffMemberItemView(_ staffMember: PharmacyStaffMember) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            PharmacyStaffMemeberView(member: staffMember, isCurrentUser: userId == staffMember.userInfo.id)
            
            // Manage staff status
            if userId != staffMember.userInfo.id {
                if staffMember.status == .pending {
                    HStack {
                        PrimaryButtonView(title: "Accept", isDisabled: vm.updateLoadingState.status != .idle,  isLoading: vm.memberIdLoading == staffMember.id) {
                            updateMember(memberId: staffMember.id, action: .approve)
                        }
                        Spacer()
                        PrimaryButtonView(title: "Reject", isDisabled: vm.updateLoadingState.status != .idle, isLoading: vm.memberIdLoading == staffMember.id, bgColor: .theme.red) {
                            updateMember(memberId: staffMember.id, action: .reject)
                        }
                    }
                } else if staffMember.status == .approved {
                    PrimaryButtonView(title: "Suspend", isDisabled: vm.updateLoadingState.status != .idle, isLoading: vm.memberIdLoading == staffMember.id, bgColor: .theme.orange) {
                        updateMember(memberId: staffMember.id, action: .suspend)
                    }
                    
                } else if staffMember.status == .suspended {
                    PrimaryButtonView(title: "Activate", isDisabled: vm.updateLoadingState.status != .idle,  isLoading: vm.memberIdLoading == staffMember.id, bgColor: .theme.blue) {
                        updateMember(memberId: staffMember.id, action: .reactivate)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func updateMember(
        memberId: String,
        action: PharmacyStaffAction,
        onCompletion: (() -> Void)? = nil
    ) {
        updateTask?.cancel()
        updateTask = Task {
            await vm.updateMember(memberId: memberId, action: action)
            onCompletion?()
        }
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let staffMembers = PharmacyStaffMember.samples.filter { $0.pharmacyId == pharmacy.id }
    
    PharmacyEditStaffScreen(
        userId: AppUser.samples[0].id,
        pharmacyService: MockPharmacyService.sample,
        pharmacyId: pharmacy.id,
        staffMembers: staffMembers
    )
}

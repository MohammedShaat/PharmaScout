//
//  PharmacyApplicationDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct PharmacyApplicationDetailScreen: View {
    
    @State private var vm: PharmacyApplicationDetailViewModel
    @State private var reviewTask: Task<Void, Never>?
    @State private var isShowingRejectionShee = false
    @Environment(\.openURL) private var openURL
    
    init(
        pharmacyService: PharmacyService,
        pharmacyId: String,
        pharmacyApplication: PharmacyApplication?
    ) {
        let viewModel = PharmacyApplicationDetailViewModel(
            pharmacyService: pharmacyService,
            pharmacyId: pharmacyId,
            pharmacyApplication: pharmacyApplication
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xLarge) {
                    basicInfoSection
                    
                    contactsSection
                    
                    workingHoursSection
                    
                    reviewHistorySection
                }
                .padding(.vertical, DesignSystem.Spacing.xLarge)
            }
            .refreshable(action: vm.refresh)
            
            if vm.canReview {
                reviewSection
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .customNavTitle(vm.pharmacyApplication?.name ?? "")
        .errorAlert(
            title: "Failed to \(vm.activeReviewAction?.title.lowercased() ?? "")",
            loadingState: $vm.reviewLoadingState
        )
        .sheet(isPresented: $isShowingRejectionShee) {
            rejectionView
        }
        .onAppear {
            vm.loadContactAndWorkingHoursIfNeeded()
        }
        .onDisappear {
            reviewTask?.cancel()
        }
        .task(vm.listenToPharmacyChanges)
        .task(vm.listenToContactChanges)
        .task(vm.listenToWokringHoursChanges)
    }
    
    private var basicInfoSection: some View {
        LoadingContentView(
            LoadingState: vm.pharmacyApplicationLoadingState,
            showMessage: vm.pharmacyApplication == nil,
            emptyTitle: "No pharmacy Application",
            emptyMessage: ""
        ) {
            if let pharmacyApplication = vm.pharmacyApplication {
                PharmacyApplicationBasicIfnoView(pharmacyApplication: pharmacyApplication)
                    .roundedBackground(
                        showBorder: true,
                        borderColor: pharmacyApplication.status == .pending ? PharmacyStatus.pending.color : .theme.disabledBackground
                    )
            }
        }
    }
    
    private var contactsSection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Text("Contact Information")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                LoadingState: vm.contactLoadingState,
                showMessage: vm.contacts.isEmpty,
                emptyTitle: "There is no contact info",
                emptyMessage: "",
                showIcon: false
            ) {
                CustomList(items: vm.contacts, isLoadingMore: false) { contact in
                    PharmacyContactView(contact: contact)
                        .clickable {
                            open(contact.makeURL(), by: openURL)
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var workingHoursSection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Text("Wokring hours")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                LoadingState: vm.workingHoursLoadingState,
                showMessage: vm.workingHours.isEmpty,
                emptyTitle: "There is no working hours info",
                emptyMessage: "",
            ) {
                WorkingHourListView(workingHours: vm.workingHours)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var reviewHistorySection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Text("Review History")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                LoadingState: vm.pharmacyApplicationLoadingState,
                showMessage: vm.pharmacyApplication == nil,
                emptyTitle: "There is no review info",
                emptyMessage: "",
            ) {
                if let pharmacyApplication = vm.pharmacyApplication {
                    PharmacyApplicationReviewHistoryView(pharmacyApplication: pharmacyApplication)
                        .padding(DesignSystem.Spacing.large)
                        .roundedBackground()
                }
            }
        }
    }
    
    private var reviewSection: some View {
        HStack {
            SecondaryButtonView(
                title: "Reject",
                systemName: "xmark",
                color: .theme.red,
                isDisabled: vm.reviewLoadingState.status != .idle && vm.activeReviewAction != .reject,
                maxWidth: .infinity
            ) {
                isShowingRejectionShee.toggle()
            }
            .frame(maxWidth: .infinity)
            
            PrimaryButtonView(
                title: "Approve",
                isDisabled: vm.reviewLoadingState.status != .idle && vm.activeReviewAction != .approve,
                isLoading: vm.reviewLoadingState.status != .idle &&  vm.activeReviewAction == .approve
            ) {
                reviewTask?.cancel()
                reviewTask = Task {
                    await vm.approvePharmacy()
                }
            }
        }
    }
    
    private var rejectionView: some View {
        PharmacyRejectionView(
            pharmacyName: vm.pharmacyApplication?.name ?? "",
            selection: $vm.rejectionReason,
            explanation: $vm.customRejectionReason,
            minCharacters: vm.minRejectionReasonLength,
            isDisabled: !vm.canReject,
            isLoading: vm.reviewLoadingState.status != .idle
        ) {
            reviewTask?.cancel()
            reviewTask = Task {
                await vm.rejectPharmacy()
                
            }
        }
    }
}

struct PharmacyApplicationDetailRoute: Hashable {
    let pharmacyId: String
    var pharmacyApplication: PharmacyApplication? = nil
}

#Preview {
    let pharmacyApplication = PharmacyApplication.samples[0]
    
    CustomNavStack {
        PharmacyApplicationDetailScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacyId: pharmacyApplication.id,
            pharmacyApplication: pharmacyApplication
        )
    }
}

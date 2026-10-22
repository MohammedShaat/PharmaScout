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
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                seeMap

                pharmacyDetailSection
                
                if vm.pharmacyApplication?.status == .pending {
                    reviewSection
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavTitle(vm.pharmacyApplication?.name ?? "")
        .sheet(isPresented: $isShowingRejectionShee) {
            rejectionView
        }
        .refreshable(action: vm.refresh)
        .onAppear {
            vm.loadContactAndWorkingHoursIfNeeded()
        }
        .onDisappear {
            reviewTask?.cancel()
        }
    }
    
    private var seeMap: some View {
        CustomNavValueLink(value: "PharmacyDestination.map(vm.pharmacy)") {
            HStack {
                Text("See location on map")
                Image(systemName: "globe")
            }
        }
    }
    
    private var pharmacyDetailSection: some View {
        VStack{
            LoadingContentView(
                LoadingState: vm.pharmacyApplicationLoadingState,
                isEmpty: vm.pharmacyApplication == nil,
                emptyMessage: "") {
                    pharmacyApplicationView
                }
            
            LoadingContentView(
                LoadingState: vm.contactLoadingState,
                isEmpty: vm.contacts.isEmpty,
                emptyMessage: "There is no contact info"
            ) {
                PharmacyContactView(contacts: vm.contacts)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            LoadingContentView(
                LoadingState: vm.workingHoursLoadingState,
                isEmpty: vm.workingHours.isEmpty,
                emptyMessage: "There is no working hours info"
            ) {
                PharmacyWorkingHoursView(workingHours: vm.workingHours)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let pharmacyApplication = vm.pharmacyApplication {
                VStack {
                    // MARK: Timezone
                    Text(pharmacyApplication.timezone)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Review info
                    if let reviewedBy = pharmacyApplication.reviewedBy,
                       let reviewedAt = pharmacyApplication.reviewedAt {
                        VStack {
                            Text("Reviewed by: \(reviewedBy)")
                            Text("Reviewed by: \(reviewedAt.formattedDateTime)")
                        }
                    }
                    
                    // MARK: Creation date
                    Text("Created at: \(pharmacyApplication.createdAt.formattedTime)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var reviewSection: some View {
        VStack {
            if let error = vm.reviewLoadingState.error {
                Text(error.errorDescription)
            }
            
            HStack {
                PrimaryButtonView(
                    title: "Approve",
                    isLoading: vm.reviewLoadingState.status != .idle) {
                        reviewTask?.cancel()
                        reviewTask = Task {
                            await vm.approvePharmacy()
                        }
                    }
                
                PrimaryButtonView(
                    title: "Reject",
                    isLoading: vm.reviewLoadingState.status != .idle) {
                        isShowingRejectionShee.toggle()
                    }
            }
        }
    }
    
    @ViewBuilder
    private var pharmacyApplicationView: some View {
        if let pharmacyApplication = vm.pharmacyApplication {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text(pharmacyApplication.address)
                    Spacer()
                    Text(pharmacyApplication.status.title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var rejectionView: some View {
        VStack {
            Spacer()
            if let pharmacyApplication = vm.pharmacyApplication {
                Text(pharmacyApplication.name)
                    .font(.title2)
            }
            
            Text("Explain why this application is being rejected. The pharmacy may use this information to correct its application and resubmit.")
            Spacer()
            
            VStack(alignment: .leading) {
                ForEach(PharmacyRejectionReason.allCases) { reason in
                    RadioView(title: reason.title, isSelected: vm.rejectionReason == reason) {
                        vm.rejectionReason = reason
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if .other == vm.rejectionReason {
                TextFieldView(title: $vm.customRejectionReason, placeholder: "Explain the reason of rejection")
            }
            Spacer()
            
            if let error = vm.reviewLoadingState.error {
                Text(error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Reject",
                isDisabled: !vm.canReject,
                isLoading: vm.reviewLoadingState.status != .idle) {
                    reviewTask?.cancel()
                    reviewTask = Task {
                        await vm.rejectPharmacy()
                        
                        if vm.reviewLoadingState.error == nil && !Task.isCancelled {
                            isShowingRejectionShee = false
                        }
                    }
                }
            
            Spacer()
        }
        .padding(DesignSystem.Spacing.xLarge)
    }
}

struct PharmacyApplicationDetailRoute: Hashable {
    let pharmacyId: String
    var pharmacyApplication: PharmacyApplication? = nil
}

#Preview {
    let pharmacyApplication = PharmacyApplication.samples[0]
    PharmacyApplicationDetailScreen(
        pharmacyService: MockPharmacyService.sample,
        pharmacyId: pharmacyApplication.id,
        pharmacyApplication: pharmacyApplication
    )
}

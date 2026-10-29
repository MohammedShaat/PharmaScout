//
//  OwnerApplicationDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct OwnerApplicationDetailScreen: View {
    @State private var vm: OwnerApplicationDetailViewModel
    @State private var task: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService, ownerApplicationId: String, ownerApplication: OwnerApplication?) {
        let viewModel = OwnerApplicationDetailViewModel(
            ownerApplicationService: ownerApplicationService,
            ownerApplicationId: ownerApplicationId,
            ownerApplication: ownerApplication
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                applicationDetailSection
                
                reviewSection
                
                revokeSection
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .refreshable(action: vm.refresh)
        .onAppear {
            vm.loadApplicationIfNeeded()
        }
        .onDisappear {
            task?.cancel()
        }
        .task(vm.listenToChanges)
    }
    
    private var applicationDetailSection: some View {
        LoadingContentView(
            LoadingState: vm.ownerApplicationLoadingState,
            isEmpty: vm.ownerApplication == nil,
            emptyMessage: "Couldn't load the application") {
                if let ownerApplication = vm.ownerApplication {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        // MARK: Code and status
                        HStack {
                            Text("Code: \(ownerApplication.code)")
                            Spacer()
                            Text("Status: \(ownerApplication.status.title)")
                        }
                        
                        // MARK: Applicant ID
                        if let applicantId = ownerApplication.applicantId {
                            Text("Applicant ID: \(applicantId)")
                        }
                        
                        // MARK: Creation and expiration
                        VStack(alignment: .leading) {
                            Text("Created by: \(ownerApplication.createdBy)")
                            Text("Created at: \(ownerApplication.createdAt.formattedDateTime)")
                            Spacer()
                            Text("Expires at: \(ownerApplication.expiresAt.formattedDateTime)")
                        }
                        
                        // MARK: Review
                        if let reviewedBy = ownerApplication.reviewedBy,
                           let reviewedAt = ownerApplication.reviewedAt {
                            VStack(alignment: .leading) {
                                Text("Reviewed by: \(reviewedBy)")
                                Spacer()
                                Text("Reviewed at: \(reviewedAt.formattedDateTime)")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
    }
    
    private var revokeSection: some View {
        VStack {
            if vm.canRevoke {
                HStack {
                    Text("Revoke")
                        .foregroundStyle(.theme.textPrimary)
                        .clickable(
                            isDisabled: vm.revokeLoadingState.status != .idle || vm.reviewLoadingState.status != .idle
                        ) {
                            task?.cancel()
                            task = Task {
                                await vm.revoke()
                            }
                        }
                    
                    if vm.revokeLoadingState.status != .idle {
                        RingProgressView()
                    }
                }
            }
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
    
    @ViewBuilder
    private var reviewSection: some View {
        if vm.canReview {
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                // MARK: Review options
                HStack(spacing: 0) {
                    Spacer()
                    RadioView(title: "Approve", isSelected: vm.approve) {
                        vm.approve = true
                    }
                    Spacer()
                    RadioView(title: "Reject", isSelected: !vm.approve) {
                        vm.approve = false
                    }
                    Spacer()
                }
                .font(.title3)
                
                // MARK: Review button
                PrimaryButtonView(
                    title: "Review",
                    isDisabled: !vm.canReview || vm.revokeLoadingState.status != .idle,
                    isLoading: vm.reviewLoadingState.status != .idle) {
                        task?.cancel()
                        task = Task {
                            await vm.review()
                        }
                    }
            }
            .padding(.vertical, DesignSystem.Spacing.xxLarge)
        }
    }
}

struct OwnerApplicationDetailRoute: Hashable {
    let applicationId: String
    let application: OwnerApplication?
    
    init(applicationId: String) {
        self.applicationId = applicationId
        self.application = nil
    }
    
    init(application: OwnerApplication) {
        self.applicationId = application.id
        self.application = application
    }
}

#Preview {
    let ownerApplication = OwnerApplication.samples[1]
    
    OwnerApplicationDetailScreen(
        ownerApplicationService: MockOwnerApplicationService.sample,
        ownerApplicationId: ownerApplication.id,
        ownerApplication: ownerApplication
    )
}

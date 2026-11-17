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
            VStack(spacing: DesignSystem.Spacing.large) {
                applicationDetailSection
                
                if vm.canReview {
                    reviewSection
                }
                
                if vm.canRevoke {
                    revokeSection
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavTitle("Application details")
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
            showMessage: vm.ownerApplication == nil,
            emptyTitle: "Couldn't load the application",
            emptyMessage: ""
        ) {
            if let ownerApplication = vm.ownerApplication {
                OwnerApplicationDetailInfoView(ownerApplication: ownerApplication)
            }
        }
    }
    
    private var revokeSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text("The code stops working immediately. This can't be undone.")
                .foregroundStyle(.theme.textSecondary)

            HStack(spacing: DesignSystem.Spacing.medium) {
                if vm.revokeLoadingState.status != .idle {
                    RingProgressView(trimColor: .theme.red)
                } else {
                    Image(systemName: "circle.slash")
                }
                
                Text("Revoke code")
                    .fontWeight(.bold)
            }
            .foregroundStyle(.theme.red)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(radius: DesignSystem.CornerRadius.small,showBorder: true, borderColor: .theme.red)
            .clickable(isDisabled: vm.revokeLoadingState.status != .idle) {
                task?.cancel()
                task = Task {
                    await vm.revoke()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var reviewSection: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Text("Review")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ApproveAndRejectView(
                selection: $vm.approve,
                approveSubtitle: "The applicant becomes a pharmacy owner.",
                rejectSubtitle: "The applicant won't become an owner."
            )
            
            PrimaryButtonView(
                title: "Review",
                isDisabled: !vm.canReview || vm.approve == nil,
                isLoading: vm.reviewLoadingState.status != .idle
            ) {
                task?.cancel()
                task = Task {
                    await vm.review()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
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
    let ownerApplication = OwnerApplication.samples[0]
    
    CustomNavStack {
        OwnerApplicationDetailScreen(
            ownerApplicationService: MockOwnerApplicationService.sample,
            ownerApplicationId: ownerApplication.id,
            ownerApplication: ownerApplication
        )
    }
}

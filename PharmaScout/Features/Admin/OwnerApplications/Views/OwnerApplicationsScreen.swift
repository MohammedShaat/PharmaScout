//
//  OwnerApplicationsScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct OwnerApplicationsScreen: View {
    private let ownerApplicationService: OwnerApplicationService
    @State private var vm: OwnerApplicationsViewModel
    @State private var applicationsTask: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService) {
        self.ownerApplicationService = ownerApplicationService
        
        let viewModel = OwnerApplicationsViewModel(ownerApplicationService: ownerApplicationService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack {
                    filterSection
                    
                    applicationListSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .customNavigationDestination(for: OwnerApplicationDetailRoute.self) { route in
                OwnerApplicationDetailScreen(
                    ownerApplicationService: ownerApplicationService,
                    ownerApplicationId: route.applicationId,
                    ownerApplication: route.application
                )
            }
            .refreshable(action: vm.refresh)
            .onAppear {
                vm.loadApplicationsIfNeeded()
            }
            .onDisappear {
                applicationsTask?.cancel()
            }
            .onChange(of: vm.filter) {
                applicationsTask?.cancel()
                applicationsTask = Task {
                    await vm.onFilterChanged()
                }
            }
            .task(vm.listenToChanges)
        }
    }
    
    private var filterSection: some View {
        Menu(vm.filter.title, systemImage: "line.3.horizontal.decrease") {
            Picker("Status", selection: $vm.filter) {
                ForEach(OwnerApplicationFilter.allCases) { status in
                    Text(status.title)
                        .tag(status)
                }
            }
        }
    }
    
    private var applicationListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            isEmpty: vm.applications.isEmpty,
            emptyMessage: "No applications") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.applications) { application in
                        CustomNavValueLink(value: OwnerApplicationDetailRoute(application: application)) {
                            ownerApplicationView(application)
                        }
                        .onAppear {
                            if application.id == vm.applications.last?.id {
                                applicationsTask?.cancel()
                                applicationsTask = Task {
                                    await vm.loadMore()
                                }
                            }
                        }
                        
                        if application.id == vm.applications.last?.id && vm.loadingState.status == .loadingMore {
                            RingProgressView()
                        }
                    }
                }
            }
    }
    
    private func ownerApplicationView(_ application: OwnerApplication) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            // MARK: Code and status
            HStack {
                Text("Code: \(application.code)")
                Spacer()
                Text("Status: \(application.status.title)")
            }
            
            // MARK: Applicant ID
            if let applicantId = application.applicantId {
                Text("Applicant ID: \(applicantId)")
            }
            
            // MARK: Creation and expiration dates
            VStack {
                Text("Created at: \(application.createdAt.formattedDateTime)")
                Spacer()
                Text("Expires at: \(application.expiresAt.formattedDateTime)")
            }
        }
        .background(.theme.primary.opacity(0.2))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OwnerApplicationsScreen(ownerApplicationService: MockOwnerApplicationService.sample)
}

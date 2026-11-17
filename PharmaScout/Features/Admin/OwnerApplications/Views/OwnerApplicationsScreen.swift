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
            VStack(spacing: DesignSystem.Spacing.large) {
                filterSection
                
                ScrollView {
                    VStack(spacing: 0) {
                        applicationListSection
                    }
                    .refreshable(action: vm.refresh)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Owner applications")
            .customNavigationDestination(for: OwnerApplicationDetailRoute.self) { route in
                OwnerApplicationDetailScreen(
                    ownerApplicationService: ownerApplicationService,
                    ownerApplicationId: route.applicationId,
                    ownerApplication: route.application
                )
            }
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
        FilterView(
            selection: $vm.filter,
            label: vm.filter.title,
            pickerTitle: "Status",
            options: OwnerApplicationFilter.allCases
        ) { status in
            Text(status.title)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var applicationListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            showMessage: vm.applications.isEmpty,
            emptyTitle: "No applications",
            emptyMessage: ""
        ) {
            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(vm.applications) { application in
                    CustomNavValueLink(
                        value: OwnerApplicationDetailRoute(application: application)
                    ) {
                        OwnerApplicationView(ownerApplication: application)
                            .padding(DesignSystem.Spacing.large)
                            .roundedBackground(
                                showBorder: true,
                                borderColor: application.status == .pending ? OwnerApplicationStatus.pending.color : .theme.disabledBackground
                            )
                    }
                    .onAppear {
                        if application.isLast(vm.applications) {
                            applicationsTask?.cancel()
                            applicationsTask = Task {
                                await vm.loadMore()
                            }
                        }
                    }
                    
                    if application.isLast(vm.applications) && vm.loadingState.status == .loadingMore {
                        RingProgressView()
                    }
                }
            }
        }
    }
}


#Preview {
    OwnerApplicationsScreen(ownerApplicationService: MockOwnerApplicationService.sample)
}

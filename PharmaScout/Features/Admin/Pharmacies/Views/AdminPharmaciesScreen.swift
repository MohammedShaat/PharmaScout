//
//  AdminPharmaciesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct AdminPharmaciesScreen: View {
    private let pharmacyService: PharmacyService
    @State private var vm: AdminPharmaciesViewModel
    @State private var applicationsTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService) {
        self.pharmacyService = pharmacyService
        
        let viewModel = AdminPharmaciesViewModel(pharmacyService: pharmacyService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            VStack(spacing: DesignSystem.Spacing.large) {
                filterSection

                ScrollView {
                    VStack {
                        pharmacyApplicationListSection
                    }
                    .refreshable(action: vm.refresh)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Pharmacy applications")
            .customNavigationDestination(for: PharmacyApplicationDetailRoute.self) { route in
                PharmacyApplicationDetailScreen(
                    pharmacyService: pharmacyService,
                    pharmacyId: route.pharmacyId,
                    pharmacyApplication: route.pharmacyApplication
                )
            }
            .onAppear {
                vm.loadPharmacyApplicationsaIfNeeded()
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
            options: PharmacyApplicationFilter.allCases
        ) { status in
            Text(status.title)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var pharmacyApplicationListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            showMessage: vm.pharmacyApplications.isEmpty,
            emptyTitle: "No applications",
            emptyMessage: ""
        ) {
            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(vm.pharmacyApplications) { pharmacyApplication in
                    CustomNavValueLink(
                        value: PharmacyApplicationDetailRoute(pharmacyId: pharmacyApplication.id, pharmacyApplication: pharmacyApplication)
                    ) {
                        PharmacyApplicationView(pharmacyApplication: pharmacyApplication)
                            .padding(DesignSystem.Spacing.large)
                            .roundedBackground(
                                showBorder: true,
                                borderColor: pharmacyApplication.status == .pending ? PharmacyStatus.pending.color : .theme.disabledBackground
                            )
                    }
                    .onAppear {
                        if pharmacyApplication.isLast(vm.pharmacyApplications) {
                            applicationsTask?.cancel()
                            applicationsTask = Task {
                                await vm.loadMore()
                            }
                        }
                    }
                    
                    if pharmacyApplication.isLast(vm.pharmacyApplications) && vm.loadingState.status == .loadingMore {
                        RingProgressView()
                    }
                }
            }
        }
    }
}

#Preview {
    AdminPharmaciesScreen(pharmacyService: MockPharmacyService.sample)
}

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
            ScrollView {
                VStack {
                    filterSection
                    
                    pharmacyApplicationListSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .customNavigationDestination(for: PharmacyApplicationDetailRoute.self) { route in
                PharmacyApplicationDetailScreen(
                    pharmacyService: pharmacyService,
                    pharmacyId: route.pharmacyId,
                    pharmacyApplication: route.pharmacyApplication
                )
            }
            .refreshable(action: vm.refresh)
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
        }
    }
    
    private var filterSection: some View {
        Menu(vm.filter.title, systemImage: "line.3.horizontal.decrease") {
            Picker("Status", selection: $vm.filter) {
                ForEach(PharmacyApplicationFilter.allCases) { status in
                    Text(status.title)
                        .tag(status)
                }
            }
        }
    }
    
    private var pharmacyApplicationListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            isEmpty: vm.pharmacyApplications.isEmpty,
            emptyMessage: "No applications") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.pharmacyApplications) { pharmacyApplication in
                        CustomNavValueLink(value: PharmacyApplicationDetailRoute(pharmacyId: pharmacyApplication.id, pharmacyApplication: pharmacyApplication)) {
                            pharmacyApplicationView(pharmacyApplication)
                        }
                        .onAppear {
                            if pharmacyApplication.id == vm.pharmacyApplications.last?.id {
                                applicationsTask?.cancel()
                                applicationsTask = Task {
                                    await vm.loadMore()
                                }
                            }
                        }
                        
                        if pharmacyApplication.id == vm.pharmacyApplications.last?.id && vm.loadingState.status == .loadingMore {
                            RingProgressView()
                        }
                    }
                }
            }
    }
    
    private func pharmacyApplicationView(_ pharmacyApplication: PharmacyApplication) -> some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            // MARK: Name, status and address
            VStack(alignment: .leading) {
                // Name and status
                HStack {
                    Text(pharmacyApplication.name)
                    Spacer()
                    Text(pharmacyApplication.status.title)
                }
                
                // Address
                Text(pharmacyApplication.address)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: Timezone
            Text(pharmacyApplication.timezone)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .background(.theme.primary.opacity(0.2))
    }
}

#Preview {
    AdminPharmaciesScreen(pharmacyService: MockPharmacyService.sample)
}

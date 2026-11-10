//
//  PharmaciesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/22/26.
//

import SwiftUI

struct PharmaciesScreen: View {
    private let pharmacyService: PharmacyService
    private let directionsService: DirectionsService
    
    @State private var vm: PharmaciesViewModel
    var path: Binding<NavigationPath>
    @State private var nearbyPharmaciesTask: Task<Void, Never>? = nil
    
    init(
        path: Binding<NavigationPath>,
        pharmacyService: PharmacyService,
        locationService: LocationService,
        directionsService: DirectionsService
    ) {
        self.path = path
        self.pharmacyService = pharmacyService
        self.directionsService = directionsService
        let viewModel = PharmaciesViewModel(pharmacyService: pharmacyService, locationService: locationService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: path) {
            VStack(spacing: 0) {
                filterSection
                    .padding(.vertical, DesignSystem.Spacing.medium)

                ScrollView {
                    VStack(spacing: 0) {
                        pharmacyListSection
                    }
                }
                .refreshable(action: vm.refresh)
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Recent searches")
            .customNavigationDestination(for: PharmacyDestination.self) { destination in
                switch destination {
                case .details(let pharmacy):
                    PharmacyDetailScreen(
                        pharmacyService: pharmacyService,
                        pharmacy: pharmacy,
                        onSeeLocationTapped: { path.wrappedValue.append(PharmacyDestination.map(pharmacy)) }
                    )
                    .id(pharmacy.id)
                    
                case .map(let pharmacy):
                    if let userCoordinate = vm.userCoordinate {
                        PharmacyMapScreen(pharmacy: pharmacy, userCoordiante: userCoordinate, directionsService: directionsService)
                    }
                }
            }
            .onAppear(perform: vm.loadNearbyPharmaciesIfNeeded)
            .onChange(of: vm.filter) {
                nearbyPharmaciesTask?.cancel()
                nearbyPharmaciesTask = Task {
                    await vm.onFilterChanged()
                }
            }
        }
    }
    
    private var filterSection: some View {
        FilterView(
            selection: $vm.filter,
            title: vm.filter.title,
            pickerTitle: "Status",
            options: PharmacyFilter.allCases,
            content: { status in
                Text(status.title)
            }
        )
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var pharmacyListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            showMessage: vm.nearbyPharmacies.isEmpty && !vm.canExpandRadius,
            emptyTitle: "No nearby pharmacies found",
            emptyMessage: "There are none within \(vm.radiusMeters.formattedDistance) of you."
        ) {
                // MARK: - Pharmacies list
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.nearbyPharmacies) { nearbyPharmacy in
                        nearbyPharmacyItem(pharmacy: nearbyPharmacy)
                            .task(id: nearbyPharmacy.id) {
                                if nearbyPharmacy.isLast(vm.nearbyPharmacies) {
                                    await vm.loadMore()
                                }
                            }
                        
                        if nearbyPharmacy.isLast(vm.nearbyPharmacies)
                            && vm.loadingState.status == .loadingMore {
                            RingProgressView()
                        }
                    }

                    // MARK: Search further
                    if vm.canExpandRadius && vm.loadingState.status == .idle {
                        Text("Search further than \(vm.radiusMeters.formattedDistance)?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.theme.green)
                            .capsuleBackground(
                                verticalPadding: DesignSystem.Spacing.medium,
                                horizontalPadding: DesignSystem.Spacing.large,
                            )
                            .clickable {
                                nearbyPharmaciesTask?.cancel()
                                nearbyPharmaciesTask = Task {
                                    await vm.searchFurther()
                                }
                            }
                    }
                }
            }
    }
    
    private func nearbyPharmacyItem(pharmacy: Pharmacy) -> some View {
        CustomNavValueLink(value: PharmacyDestination.details(pharmacy)) {
            PharmacyCardView(name: pharmacy.name, distance: pharmacy.distanceMeters, isOpen: pharmacy.isOpen)
        }
    }
}

#Preview {
    @State @Previewable var path = NavigationPath()
    
    PharmaciesScreen(
        path: $path,
        pharmacyService: MockPharmacyService.sample,
        locationService: MockLocationService.sample,
        directionsService: MockDirectionsSrevice.sample
    )
}

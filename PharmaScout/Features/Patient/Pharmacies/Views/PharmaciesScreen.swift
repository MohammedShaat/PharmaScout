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
    var path: Binding<[PharmacyDestination]>
    @State private var searchFurtherTask: Task<Void, Never>? = nil
    
    init(
        path: Binding<[PharmacyDestination]>,
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
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    
                    LoadingContentView(
                        LoadingState: vm.loadingState,
                        isEmpty: vm.nearbyPharmacies.isEmpty,
                        emptyMessage: "Couldn't find nearby pharmacies") {
                            // MARK: - Pharmacies list
                            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                                ForEach(vm.nearbyPharmacies) { nearbyPharmacy in
                                    
                                    nearbyPharmacyItem(pharmacy: nearbyPharmacy)
                                        .task(id: nearbyPharmacy.id) {
                                            if nearbyPharmacy.id == vm.nearbyPharmacies.last?.id {
                                                await vm.loadMore()
                                            }
                                        }
                                    
                                    if nearbyPharmacy.id == vm.nearbyPharmacies.last?.id  {
                                        
                                        if vm.loadingState.status == .loadingMore {
                                            RingProgressView()
                                            
                                        // MARK: Search further
                                        } else if vm.canExpandRadius {
                                            Text("Search further than \(vm.radiusMeters.meterToKilometer.formatted(.number))km?")
                                                .foregroundStyle(.theme.textPrimary)
                                                .font(.headline)
                                                .clickable {
                                                    searchFurtherTask?.cancel()
                                                    searchFurtherTask = Task {
                                                        await vm.searchFurther()
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .customNavigationDestination(for: PharmacyDestination.self) { destination in
                switch destination {
                case .details(let pharmacy):
                    PharmacyDetailScreen(pharmacyService: pharmacyService, pharmacy: pharmacy)
                    
                case .map(let pharmacy):
                    if let userCoordinate = vm.userCoordinate {
                        PharmacyMapScreen(pharmacy: pharmacy, userCoordiante: userCoordinate, directionsService: directionsService)
                    }
                }
            }
            .refreshable(action: vm.refresh)
            .taskOnFirstAppear{
                await vm.findNearbyPharmacies()
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
    @State @Previewable var path: [PharmacyDestination] = []
    
    PharmaciesScreen(
        path: $path,
        pharmacyService: MockPharmacyService.sample,
        locationService: MockLocationService.sample,
        directionsService: MockDirectionsSrevice.sample
    )
}

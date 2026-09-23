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
    @State private var searchFurtherTask: Task<Void, Never>? = nil
    
    init(
        pharmacyService: PharmacyService,
        locationService: LocationService,
        directionsService: DirectionsService
    ) {
        self.pharmacyService = pharmacyService
        self.directionsService = directionsService
        let viewModel = PharmaciesViewModel(pharmacyService: pharmacyService, locationService: locationService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    
                    switch vm.loadingState.status {
                    case .loading:
                        RingProgressView()
                        
                    case .idle, .loadingMore, .refreshing:
                        // MARK: - Pharmacies list
                        LazyVStack(spacing: DesignSystem.Spacing.medium) {
                            ForEach(vm.nearbyPharmacies) { nearbyPharmacy in
                                
                                nearbyPharmacyItem(nearbyPharmacy: nearbyPharmacy)
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
                                        Text("Search further than \(vm.radiusKm.formatted(.number))km?")
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
            }
            .customNavBarVisibility(false)
            .customNavigationDestination(for: PharmacyDestination.self, destination: { destination in
                switch destination {
                case .details(let pharmacy):
                    PharmacyDetailScreen(pharmacyService: pharmacyService, pharmacy: pharmacy)
                    
                case .map(let pharmacy):
                    if let userCoordinate = vm.userCoordinate {
                        PharmacyMapScreen(pharmacy: pharmacy, userCoordiante: userCoordinate, directionsService: directionsService)
                    }
                }
            })
            .refreshable(action: vm.refresh)
            .taskOnFirstAppear{
                await vm.findNearbyPharmacies()
            }
        }
    }
    
    @ViewBuilder
    private func nearbyPharmacyItem(nearbyPharmacy: Pharmacy) -> some View {
        let distance = nearbyPharmacy.distanceMeters.meterToKilometer.formatted(.number.precision(.fractionLength(2)))
        
        CustomNavValueLink(value: PharmacyDestination.details(nearbyPharmacy)) {
            VStack {
                Text(nearbyPharmacy.name)
                HStack {
                    Text("\(distance) km")
                    Text(nearbyPharmacy.isOpen.description)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(.gray.opacity(0.3))
        }
    }
}

enum PharmacyDestination: Hashable {
    case details(Pharmacy)
    case map(Pharmacy)
}

#Preview {
    PharmaciesScreen(
        pharmacyService: MockPharmacyService.sample,
        locationService: MockLocationService.sample,
        directionsService: MockDirectionsSrevice.sample
    )
}

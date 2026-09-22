//
//  PharmaciesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/22/26.
//

import SwiftUI

struct PharmaciesScreen: View {
    @State private var vm: PharmaciesViewModel
    @State private var searchFurtherTask: Task<Void, Never>? = nil
    
    init(pharmacyService: PharmacyService, locationService: LocationService) {
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
            .refreshable(action: vm.refresh)
            .task {
                await vm.findNearbyPharmacies()
            }
        }
    }
    
    @ViewBuilder
    private func nearbyPharmacyItem(nearbyPharmacy: Pharmacy) -> some View {
        let distance = nearbyPharmacy.distanceMeters.meterToKilometer.formatted(.number.precision(.fractionLength(2)))
        
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

#Preview {
    PharmaciesScreen(
        pharmacyService: MockPharmacyService.sample,
        locationService: MockLocationService.sample
    )
}

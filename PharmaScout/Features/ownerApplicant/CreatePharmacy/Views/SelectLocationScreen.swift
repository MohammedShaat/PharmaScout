//
//  SelectLocationScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import SwiftUI
import MapKit

struct SelectLocationScreen: View {
    private let onLocationConfirmed: (((Coordinate, ResolvedPlace)) -> Void)?
    
    @State private var vm: SelectLocationViewModel
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var suggestionsTask: Task<Void, Never>?
    @State private var addressTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    
    init(
        locationService: LocationService,
        geocodingService: GeocodingService,
        placeSearchService: PlaceSearchService,
        onLocationConfirmed: (((Coordinate, ResolvedPlace)) -> Void)? = nil
    ) {
        self.onLocationConfirmed = onLocationConfirmed
        
        let viewModel = SelectLocationViewModel(
            locationService: locationService,
            geocodingService: geocodingService,
            placeSearchService: placeSearchService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            map
            
            VStack {
                searchCompletionSection
                
                Spacer()
                
                reverseGeocodingSection
            }
            .padding(.top)
            
        }
//        .customNavBarVisibility(false)
        .task {
            vm.requestLocationPermission()
            await vm.observeSuggestionsStream()
        }
        .onDisappear {
            suggestionsTask?.cancel()
            addressTask?.cancel()
        }
        .onChange(of: vm.searchText) {
            suggestionsTask?.cancel()
            suggestionsTask = Task {
                await vm.updateQuery()
            }
        }
    }
    
    private var map: some View {
        Map(position: $cameraPosition)
        .mapControlVisibility(.visible)
        .mapControls {
            MapUserLocationButton()
            MapScaleView()
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            vm.updateRegion(
                center: context.region.center.coordiante,
                latitudeDelta: context.region.span.latitudeDelta,
                longitudeDelta: context.region.span.longitudeDelta
            )
        }
        .overlay {
            Image(systemName: "mappin")
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(.red)
                .offset(y: -18)
        }
    }
    
    private var searchCompletionSection: some View {
        VStack {
            TextFieldView(title: $vm.searchText, placeholder: "Type place to search")
                .padding()
                .background(.gray.opacity(0.4))
                .overlay {
                    if vm.suggestionsLoadingState.status != .idle {
                        RingProgressView()
                    }
                }
            
            LoadingContentView(
                LoadingState: vm.suggestionsLoadingState,
                isEmpty: vm.suggestions.isEmpty,
                emptyMessage: vm.searchText.isEmpty ? "" : "Couldn't find such a place. Try another one") {
                    ForEach(vm.suggestions) { suggestion in
                        Button(suggestion.title) {
                            Task {
                                await vm.searchPlace(for: suggestion) {
                                    if let selectedCoordiante = vm.selectedCoordiante {
                                        cameraPosition = .region(
                                            MKCoordinateRegion(
                                                center: selectedCoordiante.clLocationCoordinate2d,
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.005,
                                                    longitudeDelta: 0.005
                                                )
                                            )
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    private var reverseGeocodingSection: some View {
        VStack {
            if let error = vm.reverseGeocodingLoadingState.error {
                Text(error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Confirm location",
                isLoading: vm.reverseGeocodingLoadingState.status != .idle
            ) {
                addressTask?.cancel()
                addressTask = Task {
                    await vm.confirmLocation { coordinate, resolvedPlace in
                        onLocationConfirmed?((coordinate, resolvedPlace))
                        dismiss()
                    }
                }
            }
            .padding()
            .containerRelativeFrame(.horizontal) { width, _ in
                width / 2
            }
        }
    }
}

#Preview {
    CustomNavStack {
        SelectLocationScreen(
            locationService: MockLocationService.sample,
            geocodingService: MockGeocodingService.sample,
            placeSearchService: MockPlaceSearchService.sample
        )
    }
}

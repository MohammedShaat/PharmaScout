//
//  SelectLocationScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import SwiftUI
import MapKit

struct SelectLocationScreen: View {
    private let onLocationConfirmed: (((Coordinate?, ResolvedPlace?)) -> Void)?
    
    @State private var vm: SelectLocationViewModel
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var suggestionsTask: Task<Void, Never>?
    @State private var addressTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    
    init(
        locationService: LocationService,
        geocodingService: GeocodingService,
        placeSearchService: PlaceSearchService,
        onLocationConfirmed: (((Coordinate?, ResolvedPlace?)) -> Void)? = nil
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
            .padding([.horizontal, .top], DesignSystem.Spacing.large)
            
        }
        .customNavTitle("Choose location")
        .task {
            vm.requestLocationPermission()
            await vm.observeSuggestionsStream()
        }
        .onDisappear {
            suggestionsTask?.cancel()
            addressTask?.cancel()
        }
        .task(id: vm.searchText) {
            await vm.updateQuery()
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
            PharmacyMarkerView {}
                .offset(y: -16)
        }
    }
    
    private var searchCompletionSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            SearchFieldView(text: $vm.searchText, placehodler: "Search for a place")
            
            LoadingContentView(
                loadingState: vm.suggestionsLoadingState,
                showMessage: vm.suggestions.isEmpty && vm.searchText.isNotEmpty,
                emptyTitle: "No places found",
                emptyMessage: "Try a different name or check the spelling.",
                errorTitle: "Couldn't search for places"
            ) {
                ScrollView {
                    CustomLazyList(
                        items: vm.suggestions,
                        isLoadingMore: vm.suggestionsLoadingState.status == .loadingMore
                    ) { suggestion in
                        PlaceSuggestionView(place: suggestion)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.theme.surface.opacity(0.001))
                            .clickable(isDisabled: vm.suggestionsLoadingState.status != .idle) {
                                searchPlace(suggestion)
                            }
                    }
                }
                .containerRelativeFrame(.vertical) { height, _ in height / 2 }
            }
        }
    }
    
    private var reverseGeocodingSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            if let error = vm.reverseGeocodingLoadingState.error {
                ErrorView(title: "Couldn’t confirm location", description: error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Confirm location",
                isLoading: vm.reverseGeocodingLoadingState.status != .idle
            ) {
                addressTask?.cancel()
                addressTask = Task {
                    await vm.reverseGeocode()
                    guard !Task.isCancelled,
                          vm.reverseGeocodingLoadingState.error == nil
                    else { return }
                    onLocationConfirmed?((vm.selectedCoordiante, vm.resolvedPlace))
                    dismiss()
                }
            }
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
    
    private func searchPlace(_ suggestion: PlaceSuggestion) {
        suggestionsTask?.cancel()
        suggestionsTask = Task {
            await vm.searchPlace(for: suggestion)
            
            if !Task.isCancelled,
               vm.placeSearchingLoadingState.error == nil,
               let selectedCoordiante = vm.selectedCoordiante {
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

#Preview {
    CustomNavStack {
        SelectLocationScreen(
            locationService: MockLocationService.sample,
            geocodingService: MockGeocodingService.sample,
            placeSearchService: MockPlaceSearchService.sample
        )
    }
}

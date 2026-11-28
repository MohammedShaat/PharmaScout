//
//  PharmacyMapScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import SwiftUI
import MapKit

struct PharmacyMapScreen: View {
    let pharmacy: Pharmacy
    @State private var vm: PharmacyMapViewModel
    @State private var position: MapCameraPosition
    @State private var routeTask: Task<Void, Never>?
    
    init(pharmacy: Pharmacy, userCoordiante: Coordinate, directionsService: DirectionsService) {
        self.pharmacy = pharmacy
        
        let viewModel = PharmacyMapViewModel(
            pharmacy: pharmacy,
            userCoordinate: userCoordiante,
            directionsService: directionsService
        )
        self._vm = State(wrappedValue: viewModel)
        
        let region = MKCoordinateRegion(
            coordinates: [userCoordiante.clLocationCoordinate2d, pharmacy.clLocationCoordinate2D]
        )
        let fallbackRegion = MKCoordinateRegion(
            center: pharmacy.clLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        self._position = State(wrappedValue: .region(region ?? fallbackRegion))
    }
    
    var body: some View {
        Map(position: $position) {
            Annotation(coordinate: vm.userCoordinate.clLocationCoordinate2d) {
                meMarker
            } label: {}
            
            Annotation(coordinate: pharmacy.clLocationCoordinate2D, anchor: .bottom) {
                pharmacyMarker
            } label: {}
            
            if let route = vm.route {
                MapPolyline(
                    coordinates: route.coordinates.map { $0.clLocationCoordinate2d }
                )
                .stroke(.brightBlue, style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
        .overlay(alignment: .topLeading) {
            routeLoadingSection
        }
        .mapStyle(.standard)
        .customNavTitle(pharmacy.name)
        .task {
            await vm.loadRoute()
        }
        .onDisappear {
            routeTask?.cancel()
        }
    }
    
    private var meMarker: some View {
        UserLocationMarkerView {
            labelFor("Me")
                .foregroundStyle(.theme.brightBlue)
        }
    }
    
    private var pharmacyMarker: some View {
        PharmacyMarkerView {
            labelFor(pharmacy.name)
                .foregroundStyle(.theme.textPrimary)
        }
    }
    
    private func labelFor(_ title: String) -> some View {
        Text(title)
            .font(.footnote)
            .fontWeight(.bold)
            .padding(.vertical, DesignSystem.Spacing.xxSmall)
            .padding(.horizontal, DesignSystem.Spacing.small)
            .background(.theme.white)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
    
    @ViewBuilder
    private var routeLoadingSection: some View {
        if vm.routeLoadingState.status == .loading {
            routeLoading
        } else if let error = vm.routeLoadingState.error {
            routeErrorMessage(error)
        }
    }
    
    private var routeLoading: some View {
        HStack {
            RingProgressView(size: 15)
            Text("Finding route")
                .font(.footnote)
                .foregroundStyle(.theme.textSecondary)
        }
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground(radius: DesignSystem.CornerRadius.small)
        .padding(DesignSystem.Spacing.medium)
    }
    
    private func routeErrorMessage(_ error: AppError) -> some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // Error description
            HStack(alignment: .top) {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.theme.red)
                    .font(.footnote)
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Failed to get directions")
                        .font(.subheadline)
                        .foregroundStyle(.theme.red)
                    
                    Text(error.errorDescription)
                        .font(.footnote)
                        .foregroundStyle(.theme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Retry button
            HStack {
                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                Text("Retry")
                    .fontWeight(.heavy)
            }
            .clickable(isDisabled: vm.routeLoadingState.status != .idle) {
                routeTask?.cancel()
                routeTask = Task {
                    await vm.loadRoute()
                }
            }
            .font(.subheadline)
            .foregroundStyle(.theme.green)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(radius: DesignSystem.CornerRadius.small)
        .padding(DesignSystem.Spacing.medium)
        .shadow(radius: 5)
    }
}

#Preview {
    CustomNavStack {
        PharmacyMapScreen(
            pharmacy: .samples[0],
            userCoordiante: Coordinate(latitude: 31.522555, longitude: 34.436229),
            directionsService: MockDirectionsSrevice.sample
        )
    }
}

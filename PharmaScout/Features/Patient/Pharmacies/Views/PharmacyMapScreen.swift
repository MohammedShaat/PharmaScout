//
//  PharmacyMapScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import SwiftUI
import MapKit

struct PharmacyMapScreen: View {
    @State private var vm: PharmacyMapViewModel
    
    @State private var position: MapCameraPosition
    
    init(pharmacy: Pharmacy, userCoordiante: Coordinate, directionsService: DirectionsService) {
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
            Marker("Me", coordinate: vm.userCoordinate.clLocationCoordinate2d)
            Marker(vm.pharmacy.name, coordinate: vm.pharmacy.clLocationCoordinate2D)
            
            if let route = vm.route {
                MapPolyline(
                    coordinates: route.coordinates.map { $0.clLocationCoordinate2d }
                )
                .stroke(.blue, lineWidth: 5)
            }
        }
        .mapStyle(.standard)
        .task {
            await vm.loadRoute()
        }
    }
}

#Preview {
    PharmacyMapScreen(
        pharmacy: .samples[0],
        userCoordiante: Coordinate(latitude: 31.522555, longitude: 34.436229),
        directionsService: MockDirectionsSrevice.sample
    )
}

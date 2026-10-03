//
//  MKCoordinateRegion+Coordiantes.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import MapKit

extension MKCoordinateRegion {
    init?(coordinates: [CLLocationCoordinate2D]) {
        guard coordinates.isNotEmpty else { return nil }
        
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        let minLatitude = latitudes.min()!
        let maxLatitude = latitudes.max()!
        let minLongitude = longitudes.min()!
        let maxLongitude = longitudes.max()!

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )

        self.init(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: (maxLatitude - minLatitude) * 1.4,
                longitudeDelta: (maxLongitude - minLongitude) * 1.4
            )
        )
    }
}

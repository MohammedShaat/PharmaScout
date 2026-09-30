//
//  CLLocationCoordinate2D+Coordinate.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import CoreLocation

extension CLLocationCoordinate2D {
    var coordiante: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
}

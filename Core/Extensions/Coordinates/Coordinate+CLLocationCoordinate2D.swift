//
//  Coordinate+CLLocationCoordinate2D.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import CoreLocation

extension Coordinate {
    var clLocationCoordinate2d: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

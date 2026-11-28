//
//  Pharmacy+CLLocationCoordinate2D.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import CoreLocation

extension Pharmacy {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

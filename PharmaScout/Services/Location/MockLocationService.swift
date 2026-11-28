//
//  MockLocationService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

struct MockLocationService: LocationService {
    func requestPermission() {}
    
    func startUpdatingLocation() {}
    
    func getCurrentLocation() throws -> Coordinate {
        Coordinate(latitude: 31.522348, longitude: 34.436231)
    }
}

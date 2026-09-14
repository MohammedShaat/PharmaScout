//
//  LocationService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

protocol LocationService {
    func requestPermission()
    
    func startUpdatingLocation()
    
    func getCurrentLocation() throws -> UserLocation
}

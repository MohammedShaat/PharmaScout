//
//  DefaultLocationService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation
import CoreLocation

class DefaultLocationService: NSObject, CLLocationManagerDelegate, LocationService {
    
    private let manager = CLLocationManager()
    private var location: CLLocation?
    private var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways
        {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func getCurrentLocation() throws -> Coordinate {
        guard manager.authorizationStatus == .authorizedWhenInUse
                || manager.authorizationStatus == .authorizedAlways
        else { throw LocationError.permissionDenied }
        
        guard let location else { throw LocationError.unableToDetermineLocation }
        
        return Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

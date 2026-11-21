//
//  DefaultDirectionsService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation
import MapKit

struct DefaultDirectionsService: DirectionsService {
    func calculateRoute(from source: Coordinate, to destination: Coordinate) async throws -> MapRoute {
        let request = MKDirections.Request()
        request.source = MKMapItem(
            placemark: MKPlacemark(coordinate: source.clLocationCoordinate2d)
        )
        request.destination = MKMapItem(
            placemark: MKPlacemark(coordinate: destination.clLocationCoordinate2d)
        )
        request.transportType = .automobile
        
        do {
            let response = try await MKDirections(request: request).calculate()
            guard let mkRoute = response.routes.first else {
                throw DirectionsError.noRoute
            }
            
            let polyline = mkRoute.polyline
            var coordiantesArray = Array(repeating: CLLocationCoordinate2D(), count: polyline.pointCount)
            polyline.getCoordinates(&coordiantesArray, range: NSRange(location: 0, length: polyline.pointCount))
        
            return MapRoute(coordinates: coordiantesArray.map { $0.coordiante })
            
        } catch {
            throw error
        }
    }
}

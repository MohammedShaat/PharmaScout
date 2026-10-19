//
//  DefaultGeocodingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation
import _LocationEssentials
import CoreLocation
import MapKit

struct DefaultGeocodingService: GeocodingService {
    func reverseGeocode(_ coordiante: Coordinate) async throws -> ResolvedPlace {
        
        do {
            let location = CLLocation(latitude: coordiante.latitude, longitude: coordiante.longitude)
            
            if #available(iOS 26.0, *) {
                return try await reverseGeocodeUsingMapKit(location)
            } else {
                return try await reverseGeocodeUsingCoreLocation(location)
            }
            
        } catch {
            throw mapError(error)
        }
    }
    
    func reverseGeocodeUsingCoreLocation(_ location: CLLocation) async throws -> ResolvedPlace {
        do {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else { return .empty }
            
            let suggestedAddress = [
                placemark.thoroughfare,
                placemark.subThoroughfare,
                placemark.subLocality,
                placemark.locality
            ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        
            return ResolvedPlace(suggestedAddress: suggestedAddress, timeZone: placemark.timeZone)
            
        } catch {
            throw mapError(error)
        }
    }
    
    @available(iOS 26.0, *)
    func reverseGeocodeUsingMapKit(_ location: CLLocation) async throws -> ResolvedPlace {
        do {
            let request =  MKReverseGeocodingRequest(location: location)
            let mapItems = try await request?.mapItems
            
            guard let mapItem = mapItems?.first else { return .empty }
            
            return ResolvedPlace(suggestedAddress: mapItem.address?.fullAddress, timeZone: mapItem.timeZone)
            
        } catch {
            throw mapError(error)
        }
    }
}

extension DefaultGeocodingService {
    private func mapError(_ error: Error) -> Error {
        switch error {
        case let urlError as URLError:
            NetworkError.init(from: urlError)
            
        case let clError as CLError:
            ReversePlaceError(clError)
            
        default:
            error
        }
    }
}

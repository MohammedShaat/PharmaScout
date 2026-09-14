//
//  LocationError.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation

enum LocationError: AppError {
    case permissionDenied
    case unableToDetermineLocation
    
    var errorDescription: String {
        switch self {
        case .permissionDenied: "Location permission was denied."
            
        case .unableToDetermineLocation: "Unable to determine your location."
        }
    }
}

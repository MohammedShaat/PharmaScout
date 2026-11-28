//
//  ReversePlaceError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

enum ReversePlaceError: AppError {
    case network
    case noResult
    case partialResult
    case regionTooBroad
    case cancelled
    case denied
    case unknown(Error)

    var errorDescription: String {
        switch self {
        case .network:
            "Unable to retrieve the address. Check your internet connection and try again."

        case .noResult:
            "No address was found for this location. Try selecting a nearby point."

        case .partialResult:
            "We couldn't determine the complete address. You can enter it manually."

        case .regionTooBroad:
            "Zoom in on the map to confirm your location more accurately."

        case .cancelled:
            "The address lookup was interrupted. Please try again."

        case .denied:
            "We couldn't retrieve the address for this location. Please try again."

        case .unknown:
            "Something went wrong while retrieving the address. Please try again."
        }
    }
}

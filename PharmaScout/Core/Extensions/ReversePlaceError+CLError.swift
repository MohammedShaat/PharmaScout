//
//  ReversePlaceError+CLError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import CoreLocation

extension ReversePlaceError {
    init(_ error: CLError) {
        switch error.code {
        case .network:
            self = .network

        case .geocodeFoundNoResult:
            self = .noResult

        case .geocodeFoundPartialResult:
            self = .partialResult

        case .geocodeCanceled:
            self = .cancelled

        case .denied:
            self = .denied

        default:
            self = .unknown(error)
        }
    }
}

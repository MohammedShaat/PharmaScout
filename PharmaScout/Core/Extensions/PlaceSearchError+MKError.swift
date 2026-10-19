//
//  PlaceSearchError+MKError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import MapKit

extension PlaceSearchError {
    init(_ error: MKError) {
        switch error.code {
        case .placemarkNotFound:
            self = .suggestionNotFound

        case .loadingThrottled:
            self = .loadingThrottled

        default:
            self = .unknown
        }
    }
}

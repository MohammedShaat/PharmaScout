//
//  PlaceSearchError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

enum PlaceSearchError: AppError {
    case suggestionNotFound
    case noResults
    case loadingThrottled
    case unknown

    var errorDescription: String {
        switch self {
        case .suggestionNotFound:
            "The selected place could not be found. Please select another suggestion."
        case .noResults:
            "No places found. Try a different search."
        case .loadingThrottled:
            "Too many search requests. Please wait a moment and try again."
        case .unknown:
            "Something went wrong while searching for places. Please try again."
        }
    }
}

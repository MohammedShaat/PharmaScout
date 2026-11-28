//
//  ExpandSearchError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation

enum SearchError: AppError {
    case radiusExceedsMaximum
    case radiusMustBeGreaterThanCurrent
    case searchIsNotAwaitingContinuation
    case noPharmaciesWithinRadius
    case duplicateDrugFormulation

    var errorDescription: String {
        switch self {
        case .radiusExceedsMaximum:
            "Radius cannot exceed the maximum allowed radius"

        case .radiusMustBeGreaterThanCurrent:
            "Radius must be greater than the current radius"

        case .searchIsNotAwaitingContinuation:
            "Search is not awaiting continuation"

        case .noPharmaciesWithinRadius:
            "No pharmacies found within the search radius"

        case .duplicateDrugFormulation:
            "A drug formulation cannot appear more than once in a search"
        }
    }
}

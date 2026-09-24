//
//  AppConstants.swift
//  PharmaScout
//
//  Created by Mohammed on 9/9/26.
//

import Foundation

enum AppConstants {
    enum Timing {
        static let searchDebounceInterval: Duration = .milliseconds(500)
    }

    enum Network {
        static let pageSize = 10
    }

    enum Search {
        // Number of drugs and requests
        static let maxDrugsPerRequest = 3
        static let maxPendingRequests = 2
        
        // Distance
        static let minSearchDistanceMeters: Double = 1_000
        static let defaultSearchDistanceMeters: Double = 40_000
        static let maxSearchDistanceMeters: Double = 100_000
        static let minBrowseDistanceMeters: Double = 5_000
        static let maxBrowseDistanceMeters: Double = 100_000
        
        // Number of pharmacies
        static let minimumPharmacyCount: Int = 2
        static let defaultPharmacyCount: Int = 10
    }
}

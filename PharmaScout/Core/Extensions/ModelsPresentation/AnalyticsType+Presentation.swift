//
//  AnalyticsType+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension AnalyticsType {
    var title: String {
        switch self {
        case .pharmacySearch: "Pharmacy Search"
        case .regional: "Regional"
        }
    }

    var emptyStateTitle: String {
        switch self {
        case .pharmacySearch: "No pharmacy search data"
        case .regional: "No regional data"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .pharmacySearch:
            "Search activity will appear here once patients start searching for medicines."
        case .regional:
            "Regional insights will appear here once there's enough activity to show."
        }
    }
}

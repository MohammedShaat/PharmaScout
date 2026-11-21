//
//  PharmacyFilter+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension PharmacyFilter {
    var title: String {
        switch self {
        case .all: "All"
        case .open: "Open"
        }
    }

    var emptyStateTitle: String {
        switch self {
        case .all: "No pharmacies"
        case .open: "No open pharmacies"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .all:
            "Pharmacies will appear here once they're added."
        case .open:
            "No pharmacies are open right now. Try the All filter to see every pharmacy."
        }
    }
}

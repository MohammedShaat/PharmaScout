//
//  PharmacyApplicationFilter+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension PharmacyApplicationFilter {
    var title: String {
        switch self {
        case .all: "All"
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        case .suspended: "Suspended"
        }
    }

    var emptyStateTitle: String {
        switch self {
        case .all: "No pharmacy applications"
        default: "No \(title.lowercased()) applications"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .all:
            "Pharmacy applications will appear here once they're submitted."
        case .pending:
            "Applications waiting for review will appear here."
        case .approved:
            "Applications that have been approved will appear here."
        case .rejected:
            "Applications that were rejected will appear here."
        case .suspended:
            "Applications for pharmacies that have been suspended will appear here."
        }
    }
}

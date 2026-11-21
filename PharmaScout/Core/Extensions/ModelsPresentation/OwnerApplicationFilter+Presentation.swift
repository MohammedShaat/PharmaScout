//
//  OwnerApplicationFilter+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension OwnerApplicationFilter {
    var title: String {
        rawValue.capitalized
    }

    var emptyStateTitle: String {
        switch self {
        case .all: "No applications"
        default: "No \(title.lowercased()) applications"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .all:
            "Owner applications will appear here once they're submitted."
        case .issued:
            "Applications that have been issued will appear here."
        case .pending:
            "Applications waiting for review will appear here."
        case .approved:
            "Applications that have been approved will appear here."
        case .rejected:
            "Applications that were rejected will appear here."
        case .revoked:
            "Applications whose approval was later revoked will appear here."
        }
    }
}

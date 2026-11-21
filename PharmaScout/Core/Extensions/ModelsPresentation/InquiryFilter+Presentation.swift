//
//  InquiryFilter+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension InquiryFilter {
    var title: String {
        switch self {
        case .all: "All"
        case .pending: "Pending"
        case .answered: "Answered"
        case .expired: "Expired"
        }
    }

    var emptyStateTitle: String {
        switch self {
        case .all: "No inquiries"
        default: "No \(title.lowercased()) inquiries"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .all:
            "Medicine availability inquiries will appear here as they come in."
        case .pending:
            "Inquiries waiting for a response will appear here."
        case .answered:
            "Inquiries that have been answered will appear here."
        case .expired:
            "Inquiries that went unanswered before they expired will appear here."
        }
    }
}

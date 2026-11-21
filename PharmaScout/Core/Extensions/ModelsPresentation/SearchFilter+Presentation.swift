//
//  SearchFilter+Presentation.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import Foundation

extension SearchFilter {
    var title: String {
        switch self {
        case .all: "All"
        case .pending: "Pending"
        case .nonPending: "Not Pending"
        case .partiallyFulfilled: "Partially Fulfilled"
        case .fulfilled: "Fulfilled"
        case .unfulfilled: "Unfulfilled"
        case .awaitingContinuation: "Awaiting Continuation"
        }
    }
    
    var emptyStateTitle: String {
        switch self {
        case .all: "No recent searches"
        case .pending: "No pending searches"
        case .nonPending: "No completed searches"
        case .partiallyFulfilled: "No partially fulfilled searches"
        case .fulfilled: "No fulfilled searches"
        case .unfulfilled: "No unfulfilled searches"
        case .awaitingContinuation: "Nothing awaiting your input"
        }
    }

    var emptyStateMessage: String {
        switch self {
        case .all:
            "Medicines you search for will show up here, so you can quickly check them again."
        case .pending:
            "Searches will appear here while pharmacies are still replying."
        case .nonPending:
            "Searches that pharmacies have finished responding to will appear here."
        case .partiallyFulfilled:
            "Searches where pharmacies could only provide part of what you asked for will appear here."
        case .fulfilled:
            "Searches where a pharmacy confirmed your medicine is available will appear here."
        case .unfulfilled:
            "Searches where no pharmacy had your medicine will appear here."
        case .awaitingContinuation:
            "Searches that need your input to continue will appear here."
        }
    }
}

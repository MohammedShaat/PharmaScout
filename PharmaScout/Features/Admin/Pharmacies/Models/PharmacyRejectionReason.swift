//
//  PharmacyRejectionReason.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

enum PharmacyRejectionReason: CaseIterable, Identifiable {
    case incompleteInformation
    case invalidInformation
    case duplicateApplication
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .incompleteInformation:
            "Incomplete information"
        case .invalidInformation:
            "Invalid information"
        case .duplicateApplication:
            "Duplicate application"
        case .other:
            "Other"
        }
    }
}

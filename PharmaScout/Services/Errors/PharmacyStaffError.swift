//
//  PharmacyStaffError.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

enum PharmacyStaffError: AppError {
    case notFound

    var errorDescription: String {
        switch self {
        case .notFound:
            "Pharmacy information is unavailable. Please contact your administrator."
        }
    }
}

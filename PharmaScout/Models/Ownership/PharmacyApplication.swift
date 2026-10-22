//
//  PharmacyApplication.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

struct PharmacyApplication: nonisolated Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let address: String
    let timezone: String
    let status: PharmacyStatus
    let createdAt: Date
    let reviewedBy: String?
    let reviewedAt: Date?
    let rejectionReason: String?
}

enum PharmacyApplicationFilter: String, Codable, CaseIterable, Identifiable {
    case all
    case pending
    case approved
    case rejected
    case suspended
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .all: "All"
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        case .suspended: "Suspended"
        }
    }
}

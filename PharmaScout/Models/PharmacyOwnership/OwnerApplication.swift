//
//  OwnerApplication.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

struct OwnerApplication: nonisolated Codable, Identifiable, Hashable {
    let id: String
    let code: String
    let createdBy: String
    let applicantId: String?
    let status: OwnerApplicationStatus
    let expiresAt: Date
    let redeemedAt: Date?
    let reviewedBy: String?
    let reviewedAt: Date?
    let createdAt: Date
}

enum OwnerApplicationStatus: String, Codable {
    case issued
    case pending
    case approved
    case rejected
    case revoked
    
    var title: String {
        switch self {
        case .issued:
            "issued"
        case .pending:
            "pending"
        case .approved:
            "approved"
        case .rejected:
            "rejected"
        case .revoked:
            "revoked"
        }
    }
}

enum OwnerApplicationFilter: String, Codable, CaseIterable, Identifiable {
    case all
    case issued
    case pending
    case approved
    case rejected
    case revoked
    
    var id: Self { self }
    
    var title: String {
        rawValue.capitalized
    }
}

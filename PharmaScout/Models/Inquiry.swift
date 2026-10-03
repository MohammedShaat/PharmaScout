//
//  Inquiry.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

struct Inquiry: nonisolated Codable, Identifiable, Hashable {
    let id: String
    let genericName: String
    let drugFormulation: DrugFormulation
    let pharmacyId: String
    let status: InquiryStatus
    let response: InquiryResponse?
    let substituteGenericName: String?
    let substituteDrugFormulation: DrugFormulation?
    let createdAt: Date
    let respondedAt: Date?
}

enum InquiryResponse: String, Codable, CaseIterable {
    case available = "available"
    case unavailable = "unavailable"
    case substitute = "substitute"
}

enum InquiryStatus: String, Codable {
    case pending = "pending"
    case answered = "answered"
    case expired = "expired"
}

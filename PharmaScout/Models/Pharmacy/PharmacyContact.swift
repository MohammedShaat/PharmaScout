//
//  PharmacyContact.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import Foundation

struct PharmacyContact: Identifiable, Codable {
    let id: String
    let pharmacyId: String
    let title: String
    let type: ContactType
    let value: String
}

enum ContactType: String, Codable {
    case number = "number"
    case link = "link"
    case email = "email"
}

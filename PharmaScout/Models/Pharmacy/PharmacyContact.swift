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
    var title: String
    var type: ContactType
    var value: String
}

enum ContactType: String, Codable, CaseIterable {
    case number = "number"
    case link = "link"
    case email = "email"
}

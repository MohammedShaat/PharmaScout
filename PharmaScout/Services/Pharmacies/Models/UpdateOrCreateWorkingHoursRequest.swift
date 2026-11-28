//
//  UpdateOrCreateWorkingHoursRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

struct UpdateOrCreatePharmacyHoursRequest: Codable {
    let hours: [UpdatePharmacyHour]
}

struct UpdatePharmacyHour: Codable {
    let id: String
    let pharmacyId: String
    let day: Int
    let opensAt: String
    let closesAt: String

    init(_ hour: WorkingHour, pharmacyId: String) {
        self.id = hour.id
        self.pharmacyId = pharmacyId
        self.day = hour.day.toIndex()
        self.opensAt = hour.opensAt.timeString
        self.closesAt = hour.closesAt.timeString
    }
}

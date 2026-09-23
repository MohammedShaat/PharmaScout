//
//  WorkingHour.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import Foundation

struct WorkingHour: Codable, Identifiable {
    let id: String
    let pharmacyId: String
    let day: Int
    let opensAt: String
    let closesAt: String
}

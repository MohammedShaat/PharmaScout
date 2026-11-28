//
//  PharmacySearchAnalytics.swift
//  PharmaScout
//
//  Created by Mohammed on 10/11/26.
//

import Foundation

struct PharmacySearchAnalytics: nonisolated Codable {
    let drugDemands: [DrugDemand]
    let totalDrugsRequested: Int
    let totalDrugsAnswered: Int
    let totalDrugsAnsweredAvailable: Int
}

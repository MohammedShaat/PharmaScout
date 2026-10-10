//
//  AnalyticDemand.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

struct DrugDemand: Codable, Identifiable {
    var id: String { drugFormulation.id }
    let drugFormulation: DrugFormulation
    let genericName: String
    let patientCount: Int
}

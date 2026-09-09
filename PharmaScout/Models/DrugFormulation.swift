//
//  DrugFormulation.swift
//  PharmaScout
//
//  Created by Mohammed on 9/10/26.
//

import Foundation

struct DrugFormulation: Codable, Identifiable {
    let id: String
    let genericDrugId: String
    let strength: String
    let route: String
    let form: String
    
    var title: String {
        "\(strength) \(route) \(form)"
    }
}

enum DrugForm: String {
    case tablet = "tablet"
    case capsule = "capsule"
    case syrup = "syrup"
    case suspension = "suspension"
    case cream = "cream"
    case ointment = "ointment"
    case gel = "gel"
    case solution = "solution"
    case drops = "drops"
    case injection = "injection"
}

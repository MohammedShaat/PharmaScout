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

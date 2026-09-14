//
//  SelectedDrug.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//


import Foundation

@Observable
class SelectedDrug: Hashable, Identifiable {
    let id: String = UUID().uuidString
    var genericDrug: GenericDrug
    var formulation: DrugFormulation
    
    init(from genericDrug: GenericDrug, and drugFormulation: DrugFormulation) {
        self.genericDrug = genericDrug
        self.formulation = drugFormulation
    }
    
    static func ==(lhs: SelectedDrug, rhs: SelectedDrug) -> Bool {
        lhs.genericDrug == rhs.genericDrug
        && lhs.formulation == rhs.formulation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

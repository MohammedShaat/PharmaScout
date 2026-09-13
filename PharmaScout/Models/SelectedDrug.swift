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
    var quanity: Int
    
    init(from genericDrug: GenericDrug, and drugFormulation: DrugFormulation, quantity: Int) {
        self.genericDrug = genericDrug
        self.formulation = drugFormulation
        self.quanity = quantity
    }
    
    static func ==(lhs: SelectedDrug, rhs: SelectedDrug) -> Bool {
        lhs.genericDrug == rhs.genericDrug
        && lhs.formulation == rhs.formulation
        && lhs.quanity == rhs.quanity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  GenericDrug+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

extension GenericDrug {
    static let samples: [GenericDrug] = [
       
        GenericDrug(
            id: UUID().uuidString,
            genericName: "Amoxicillin + Clavulanic Acid"
        ),

        GenericDrug(
            id: UUID().uuidString,
            genericName: "Paracetamol"
        ),

        GenericDrug(
            id: UUID().uuidString,
            genericName: "Ibuprofen"
        ),

        GenericDrug(
            id: UUID().uuidString,
            genericName: "Amoxicillin"
        ),

        GenericDrug(
            id: UUID().uuidString,
            genericName: "Diclofenac"
        ),

    ]
}

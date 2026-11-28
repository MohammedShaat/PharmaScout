//
//  DrugDemand+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

extension DrugDemand {
    static let samples = DrugFormulation.samples.map { formulation in
        let genericName = GenericDrug.samples.first { $0.id == formulation.genericDrugId }!.genericName
        
        return DrugDemand(
            drugFormulation: formulation,
            genericName: genericName,
            patientCount: .random(in: 5...50)
        )
    }
}

//
//  DrugFormulation+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/10/26.
//

import Foundation

extension DrugFormulation {
    static let samples: [DrugFormulation] = [

        // MARK: - Amoxicillin + Clavulanic Acid

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[0].id,
            strength: "875 MG / 125 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[0].id,
            strength: "500 MG / 125 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[0].id,
            strength: "400 MG / 57 MG per 5 ML",
            route: "Oral",
            form: "Suspension"
        ),


        // MARK: - Paracetamol

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[1].id,
            strength: "500 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[1].id,
            strength: "120 MG / 5 ML",
            route: "Oral",
            form: "Suspension"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[1].id,
            strength: "1 G",
            route: "Rectal",
            form: "Suppository"
        ),


        // MARK: - Ibuprofen

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[2].id,
            strength: "200 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[2].id,
            strength: "400 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[2].id,
            strength: "100 MG / 5 ML",
            route: "Oral",
            form: "Suspension"
        ),


        // MARK: - Amoxicillin

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[3].id,
            strength: "250 MG",
            route: "Oral",
            form: "Capsule"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[3].id,
            strength: "500 MG",
            route: "Oral",
            form: "Capsule"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[3].id,
            strength: "125 MG / 5 ML",
            route: "Oral",
            form: "Suspension"
        ),


        // MARK: - Diclofenac

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[4].id,
            strength: "50 MG",
            route: "Oral",
            form: "Tablet"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[4].id,
            strength: "75 MG / 3 ML",
            route: "Intramuscular",
            form: "Injection"
        ),

        DrugFormulation(
            id: UUID().uuidString,
            genericDrugId: GenericDrug.samples[4].id,
            strength: "1%",
            route: "Topical",
            form: "Gel"
        ),
    ]
}

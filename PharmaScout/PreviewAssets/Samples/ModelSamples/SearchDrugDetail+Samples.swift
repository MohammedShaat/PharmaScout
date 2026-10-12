//
//  SearchDrugDetail+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import Foundation

extension SearchDrugDetail {
    static let samples: [SearchDrugDetail] = [

        // MARK: - Search 001

        SearchDrugDetail(
            id: "item-001",
            genericName: "Amoxicillin",
            drugFormulation: DrugFormulation.samples[10],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-001",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-002",
            genericName: "Ibuprofen",
            drugFormulation: DrugFormulation.samples[6],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-002",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 002

        SearchDrugDetail(
            id: "item-003",
            genericName: "Paracetamol",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-003",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-004",
            genericName: "Omeprazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-004",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-005",
            genericName: "Cetirizine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-005",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .substitute,
                substituteGenericName: "Loratadine",
                substituteDrugFormulation: DrugFormulation.samples[4]
            )
        ),

        // MARK: - Search 003

        SearchDrugDetail(
            id: "item-006",
            genericName: "Azithromycin",
            drugFormulation: DrugFormulation.samples[10],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-006",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .substitute,
                substituteGenericName: "Clarithromycin",
                substituteDrugFormulation: DrugFormulation.samples[9]
            )
        ),

        // MARK: - Search 004

        SearchDrugDetail(
            id: "item-007",
            genericName: "Metformin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-007",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-008",
            genericName: "Atorvastatin",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        // MARK: - Search 005

        SearchDrugDetail(
            id: "item-009",
            genericName: "Loratadine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-009",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-010",
            genericName: "Omeprazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-010",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 006

        SearchDrugDetail(
            id: "item-011",
            genericName: "Amoxicillin",
            drugFormulation: DrugFormulation.samples[9],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-011",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-012",
            genericName: "Paracetamol",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-012",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-013",
            genericName: "Diclofenac",
            drugFormulation: DrugFormulation.samples[11],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-013",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .substitute,
                substituteGenericName: "Ibuprofen",
                substituteDrugFormulation: DrugFormulation.samples[6]
            )
        ),

        // MARK: - Search 007

        SearchDrugDetail(
            id: "item-014",
            genericName: "Azithromycin",
            drugFormulation: DrugFormulation.samples[9],
            status: .unfulfilled,
            response: SearchDrugResponse(
                id: "response-014",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .unavailable,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 008

        SearchDrugDetail(
            id: "item-015",
            genericName: "Metformin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-015",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-016",
            genericName: "Amlodipine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-016",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-017",
            genericName: "Atorvastatin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-017",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-018",
            genericName: "Aspirin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-018",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 009

        SearchDrugDetail(
            id: "item-019",
            genericName: "Cetirizine",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        SearchDrugDetail(
            id: "item-020",
            genericName: "Salbutamol",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        // MARK: - Search 010

        SearchDrugDetail(
            id: "item-021",
            genericName: "Ibuprofen",
            drugFormulation: DrugFormulation.samples[7],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-021",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-022",
            genericName: "Pantoprazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-022",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-023",
            genericName: "Loratadine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-023",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .substitute,
                substituteGenericName: "Cetirizine",
                substituteDrugFormulation: DrugFormulation.samples[3]
            )
        ),

        // MARK: - Search 011

        SearchDrugDetail(
            id: "item-024",
            genericName: "Amoxicillin",
            drugFormulation: DrugFormulation.samples[10],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-024",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 012

        SearchDrugDetail(
            id: "item-025",
            genericName: "Losartan",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-025",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-026",
            genericName: "Metformin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-026",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .substitute,
                substituteGenericName: "Gliclazide",
                substituteDrugFormulation: DrugFormulation.samples[2]
            )
        ),

        // MARK: - Search 013

        SearchDrugDetail(
            id: "item-027",
            genericName: "Clarithromycin",
            drugFormulation: DrugFormulation.samples[9],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-027",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .substitute,
                substituteGenericName: "Azithromycin",
                substituteDrugFormulation: DrugFormulation.samples[10]
            )
        ),

        // MARK: - Search 014

        SearchDrugDetail(
            id: "item-028",
            genericName: "Paracetamol",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-028",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-029",
            genericName: "Ibuprofen",
            drugFormulation: DrugFormulation.samples[6],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-029",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-030",
            genericName: "Cetirizine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-030",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-031",
            genericName: "Omeprazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-031",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-032",
            genericName: "Diclofenac",
            drugFormulation: DrugFormulation.samples[11],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-032",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 015

        SearchDrugDetail(
            id: "item-033",
            genericName: "Insulin Glargine",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        SearchDrugDetail(
            id: "item-034",
            genericName: "Metformin",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        SearchDrugDetail(
            id: "item-035",
            genericName: "Gliclazide",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        // MARK: - Search 016

        SearchDrugDetail(
            id: "item-036",
            genericName: "Sertraline",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-036",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-037",
            genericName: "Quetiapine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-037",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 017

        SearchDrugDetail(
            id: "item-038",
            genericName: "Amlodipine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-038",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-039",
            genericName: "Losartan",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-039",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-040",
            genericName: "Atorvastatin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-040",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-041",
            genericName: "Aspirin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-041",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .substitute,
                substituteGenericName: "Clopidogrel",
                substituteDrugFormulation: DrugFormulation.samples[3]
            )
        ),

        // MARK: - Search 018

        SearchDrugDetail(
            id: "item-042",
            genericName: "Salbutamol",
            drugFormulation: DrugFormulation.samples[3],
            status: .unfulfilled,
            response: SearchDrugResponse(
                id: "response-042",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .unavailable,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 019

        SearchDrugDetail(
            id: "item-043",
            genericName: "Esomeprazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-043",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-044",
            genericName: "Domperidone",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-044",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-045",
            genericName: "Dicyclomine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-045",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 020

        SearchDrugDetail(
            id: "item-046",
            genericName: "Hydrochlorothiazide",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-046",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-047",
            genericName: "Lisinopril",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-047",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .substitute,
                substituteGenericName: "Enalapril",
                substituteDrugFormulation: DrugFormulation.samples[3]
            )
        ),

        // MARK: - Search 021

        SearchDrugDetail(
            id: "item-048",
            genericName: "Cefuroxime",
            drugFormulation: DrugFormulation.samples[3],
            status: .pending,
            response: nil
        ),

        // MARK: - Search 022

        SearchDrugDetail(
            id: "item-049",
            genericName: "Levothyroxine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-049",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-050",
            genericName: "Metformin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-050",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-051",
            genericName: "Atorvastatin",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-051",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-052",
            genericName: "Amlodipine",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-052",
                pharmacy: Pharmacy.samples[3],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        // MARK: - Search 023

        SearchDrugDetail(
            id: "item-053",
            genericName: "Fluconazole",
            drugFormulation: DrugFormulation.samples[3],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-053",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .available,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-054",
            genericName: "Clotrimazole",
            drugFormulation: DrugFormulation.samples[11],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-054",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .substitute,
                substituteGenericName: "Miconazole",
                substituteDrugFormulation: DrugFormulation.samples[11]
            )
        ),

        // MARK: - Search 024

        SearchDrugDetail(
            id: "item-055",
            genericName: "Amoxicillin",
            drugFormulation: DrugFormulation.samples[0],
            status: .unfulfilled,
            response: SearchDrugResponse(
                id: "response-055",
                pharmacy: Pharmacy.samples[0],
                pharmacyResponse: .unavailable,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-056",
            genericName: "Clavulanic Acid",
            drugFormulation: DrugFormulation.samples[1],
            status: .unfulfilled,
            response: SearchDrugResponse(
                id: "response-056",
                pharmacy: Pharmacy.samples[1],
                pharmacyResponse: .unavailable,
                substituteGenericName: nil,
                substituteDrugFormulation: nil
            )
        ),

        SearchDrugDetail(
            id: "item-057",
            genericName: "Azithromycin",
            drugFormulation: DrugFormulation.samples[10],
            status: .fulfilled,
            response: SearchDrugResponse(
                id: "response-057",
                pharmacy: Pharmacy.samples[2],
                pharmacyResponse: .substitute,
                substituteGenericName: "Erythromycin",
                substituteDrugFormulation: DrugFormulation.samples[9]
            )
        )
    ]
}

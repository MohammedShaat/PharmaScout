//
//  Search+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import Foundation

extension Search {
    static let samples = [
        Search(
            id: "search-001",
            fulfilmentMode: .singlePharmacy,
            acceptSubstitute: false,
            drugsCount: 2,
            fulfilledDrugsCount: 2,
            status: .fulfilled,
            drugs: [
                SearchDrug(
                    id: "item-001",
                    genericName: "Amoxicillin",
                    strength: "500 mg"
                ),
                SearchDrug(
                    id: "item-002",
                    genericName: "Ibuprofen",
                    strength: "200 mg"
                )
            ],
            createdAt: Date()
        ),

        Search(
            id: "search-002",
            fulfilmentMode: .multiPharmacy,
            acceptSubstitute: true,
            drugsCount: 3,
            fulfilledDrugsCount: 2,
            status: .partiallyFulfilled,
            drugs: [
                SearchDrug(
                    id: "item-003",
                    genericName: "Paracetamol",
                    strength: "500 mg"
                ),
                SearchDrug(
                    id: "item-004",
                    genericName: "Omeprazole",
                    strength: "20 mg"
                ),
                SearchDrug(
                    id: "item-005",
                    genericName: "Cetirizine",
                    strength: "10 mg"
                )
            ],
            createdAt: Date().addingTimeInterval(-3600)
        ),

        Search(
            id: "search-003",
            fulfilmentMode: .singlePharmacy,
            acceptSubstitute: false,
            drugsCount: 1,
            fulfilledDrugsCount: 0,
            status: .unfulfilled,
            drugs: [
                SearchDrug(
                    id: "item-006",
                    genericName: "Azithromycin",
                    strength: "500 mg"
                )
            ],
            createdAt: Date().addingTimeInterval(-86400)
        ),

        Search(
            id: "search-004",
            fulfilmentMode: .multiPharmacy,
            acceptSubstitute: false,
            drugsCount: 2,
            fulfilledDrugsCount: 1,
            status: .pending,
            drugs: [
                SearchDrug(
                    id: "item-007",
                    genericName: "Metformin",
                    strength: "500 mg"
                ),
                SearchDrug(
                    id: "item-008",
                    genericName: "Atorvastatin",
                    strength: "20 mg"
                )
            ],
            createdAt: Date().addingTimeInterval(-300)
        ),
        
        Search(
                id: "search-005",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: true,
                drugsCount: 2,
                fulfilledDrugsCount: 2,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-009", genericName: "Loratadine", strength: "10 mg"),
                    SearchDrug(id: "item-010", genericName: "Omeprazole", strength: "20 mg")
                ],
                createdAt: Date().addingTimeInterval(-172800)
            ),

            Search(
                id: "search-006",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 3,
                fulfilledDrugsCount: 1,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-011", genericName: "Amoxicillin", strength: "250 mg"),
                    SearchDrug(id: "item-012", genericName: "Paracetamol", strength: "500 mg"),
                    SearchDrug(id: "item-013", genericName: "Diclofenac", strength: "50 mg")
                ],
                createdAt: Date().addingTimeInterval(-259200)
            ),

            Search(
                id: "search-007",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: false,
                drugsCount: 1,
                fulfilledDrugsCount: 0,
                status: .unfulfilled,
                drugs: [
                    SearchDrug(id: "item-014", genericName: "Azithromycin", strength: "250 mg")
                ],
                createdAt: Date().addingTimeInterval(-345600)
            ),

            Search(
                id: "search-008",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: true,
                drugsCount: 4,
                fulfilledDrugsCount: 4,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-015", genericName: "Metformin", strength: "500 mg"),
                    SearchDrug(id: "item-016", genericName: "Amlodipine", strength: "5 mg"),
                    SearchDrug(id: "item-017", genericName: "Atorvastatin", strength: "20 mg"),
                    SearchDrug(id: "item-018", genericName: "Aspirin", strength: "81 mg")
                ],
                createdAt: Date().addingTimeInterval(-432000)
            ),

            Search(
                id: "search-009",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: false,
                drugsCount: 2,
                fulfilledDrugsCount: 0,
                status: .pending,
                drugs: [
                    SearchDrug(id: "item-019", genericName: "Cetirizine", strength: "10 mg"),
                    SearchDrug(id: "item-020", genericName: "Salbutamol", strength: "100 mcg")
                ],
                createdAt: Date().addingTimeInterval(-600)
            ),

            Search(
                id: "search-010",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: true,
                drugsCount: 3,
                fulfilledDrugsCount: 2,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-021", genericName: "Ibuprofen", strength: "400 mg"),
                    SearchDrug(id: "item-022", genericName: "Pantoprazole", strength: "40 mg"),
                    SearchDrug(id: "item-023", genericName: "Loratadine", strength: "10 mg")
                ],
                createdAt: Date().addingTimeInterval(-518400)
            ),

            Search(
                id: "search-011",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: true,
                drugsCount: 1,
                fulfilledDrugsCount: 1,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-024", genericName: "Amoxicillin", strength: "500 mg")
                ],
                createdAt: Date().addingTimeInterval(-604800)
            ),

            Search(
                id: "search-012",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 2,
                fulfilledDrugsCount: 1,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-025", genericName: "Losartan", strength: "50 mg"),
                    SearchDrug(id: "item-026", genericName: "Metformin", strength: "850 mg")
                ],
                createdAt: Date().addingTimeInterval(-691200)
            ),

            Search(
                id: "search-013",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: false,
                drugsCount: 1,
                fulfilledDrugsCount: 0,
                status: .unfulfilled,
                drugs: [
                    SearchDrug(id: "item-027", genericName: "Clarithromycin", strength: "500 mg")
                ],
                createdAt: Date().addingTimeInterval(-777600)
            ),

            Search(
                id: "search-014",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: true,
                drugsCount: 5,
                fulfilledDrugsCount: 5,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-028", genericName: "Paracetamol", strength: "500 mg"),
                    SearchDrug(id: "item-029", genericName: "Ibuprofen", strength: "200 mg"),
                    SearchDrug(id: "item-030", genericName: "Cetirizine", strength: "10 mg"),
                    SearchDrug(id: "item-031", genericName: "Omeprazole", strength: "20 mg"),
                    SearchDrug(id: "item-032", genericName: "Diclofenac", strength: "50 mg")
                ],
                createdAt: Date().addingTimeInterval(-864000)
            ),

            Search(
                id: "search-015",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: false,
                drugsCount: 3,
                fulfilledDrugsCount: 0,
                status: .pending,
                drugs: [
                    SearchDrug(id: "item-033", genericName: "Insulin Glargine", strength: "100 units/mL"),
                    SearchDrug(id: "item-034", genericName: "Metformin", strength: "500 mg"),
                    SearchDrug(id: "item-035", genericName: "Gliclazide", strength: "80 mg")
                ],
                createdAt: Date().addingTimeInterval(-900)
            ),

            Search(
                id: "search-016",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 2,
                fulfilledDrugsCount: 2,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-036", genericName: "Sertraline", strength: "50 mg"),
                    SearchDrug(id: "item-037", genericName: "Quetiapine", strength: "25 mg")
                ],
                createdAt: Date().addingTimeInterval(-950400)
            ),

            Search(
                id: "search-017",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: true,
                drugsCount: 4,
                fulfilledDrugsCount: 3,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-038", genericName: "Amlodipine", strength: "10 mg"),
                    SearchDrug(id: "item-039", genericName: "Losartan", strength: "100 mg"),
                    SearchDrug(id: "item-040", genericName: "Atorvastatin", strength: "40 mg"),
                    SearchDrug(id: "item-041", genericName: "Aspirin", strength: "81 mg")
                ],
                createdAt: Date().addingTimeInterval(-1036800)
            ),

            Search(
                id: "search-018",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 1,
                fulfilledDrugsCount: 0,
                status: .unfulfilled,
                drugs: [
                    SearchDrug(id: "item-042", genericName: "Salbutamol", strength: "100 mcg")
                ],
                createdAt: Date().addingTimeInterval(-1123200)
            ),

            Search(
                id: "search-019",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: true,
                drugsCount: 3,
                fulfilledDrugsCount: 3,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-043", genericName: "Esomeprazole", strength: "40 mg"),
                    SearchDrug(id: "item-044", genericName: "Domperidone", strength: "10 mg"),
                    SearchDrug(id: "item-045", genericName: "Dicyclomine", strength: "20 mg")
                ],
                createdAt: Date().addingTimeInterval(-1209600)
            ),

            Search(
                id: "search-020",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: true,
                drugsCount: 2,
                fulfilledDrugsCount: 1,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-046", genericName: "Hydrochlorothiazide", strength: "25 mg"),
                    SearchDrug(id: "item-047", genericName: "Lisinopril", strength: "10 mg")
                ],
                createdAt: Date().addingTimeInterval(-1296000)
            ),

            Search(
                id: "search-021",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: false,
                drugsCount: 1,
                fulfilledDrugsCount: 0,
                status: .pending,
                drugs: [
                    SearchDrug(id: "item-048", genericName: "Cefuroxime", strength: "500 mg")
                ],
                createdAt: Date().addingTimeInterval(-1200)
            ),

            Search(
                id: "search-022",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 4,
                fulfilledDrugsCount: 4,
                status: .fulfilled,
                drugs: [
                    SearchDrug(id: "item-049", genericName: "Levothyroxine", strength: "50 mcg"),
                    SearchDrug(id: "item-050", genericName: "Metformin", strength: "1000 mg"),
                    SearchDrug(id: "item-051", genericName: "Atorvastatin", strength: "20 mg"),
                    SearchDrug(id: "item-052", genericName: "Amlodipine", strength: "5 mg")
                ],
                createdAt: Date().addingTimeInterval(-1382400)
            ),

            Search(
                id: "search-023",
                fulfilmentMode: .singlePharmacy,
                acceptSubstitute: true,
                drugsCount: 2,
                fulfilledDrugsCount: 1,
                status: .partiallyFulfilled,
                drugs: [
                    SearchDrug(id: "item-053", genericName: "Fluconazole", strength: "150 mg"),
                    SearchDrug(id: "item-054", genericName: "Clotrimazole", strength: "1%")
                ],
                createdAt: Date().addingTimeInterval(-1468800)
            ),

            Search(
                id: "search-024",
                fulfilmentMode: .multiPharmacy,
                acceptSubstitute: false,
                drugsCount: 3,
                fulfilledDrugsCount: 0,
                status: .unfulfilled,
                drugs: [
                    SearchDrug(id: "item-055", genericName: "Amoxicillin", strength: "875 mg"),
                    SearchDrug(id: "item-056", genericName: "Clavulanic Acid", strength: "125 mg"),
                    SearchDrug(id: "item-057", genericName: "Azithromycin", strength: "500 mg")
                ],
                createdAt: Date().addingTimeInterval(-1555200)
            )
    ]
}

//
//  Inquiry+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

extension Inquiry {
    static let samples: [Inquiry] = (0..<30).map { index in
        let status: InquiryStatus
        let response: InquiryResponse?
        let substituteDrugFormulationId: String?

        switch index % 3 {
        case 0:
            status = .answered
            response = .available
            substituteDrugFormulationId = nil

        case 1:
            status = .answered
            response = .unavailable
            substituteDrugFormulationId = nil
            
        default:
            status = .pending
            response = nil
            substituteDrugFormulationId = DrugFormulation.samples.randomElement()?.id
            ?? "formulation-\((index % 10) + 1)"
        }

        let createdAt = Calendar.current.date(
            byAdding: .hour,
            value: -(Int(index) + 1),
            to: Date()
        )!
        
        let drugFormulation = DrugFormulation.samples.randomElement()!
        let genericName = GenericDrug.samples.first { $0.id == drugFormulation.genericDrugId }!.genericName
        let substituteGenericName = response == .substitute
        ? GenericDrug.samples.first {
            $0.id == drugFormulation.genericDrugId && $0.id != drugFormulation.genericDrugId
        }!.genericName
        : nil

        return Inquiry(
            id: "inquiry-\(index + 1)",
            genericName: genericName,
            drugFormulation: drugFormulation,
            pharmacyId: Pharmacy.samples[0].id,
            status: status,
            response: response,
            substituteGenericName: substituteGenericName,
            substituteDrugFormulation: .samples.randomElement()!,
            createdAt: createdAt,
            respondedAt: createdAt.addingTimeInterval(
                TimeInterval((index + 1) * 60)
            )
        )
    }
}

//
//  RespondToInquiry.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation


struct RespondToInquiryParams: Codable {
    let pharmacyId: String
    let response: InquiryResponse
    let substituteDrugFormulationId: String?
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "p_pharmacy_id"
        case response = "p_response"
        case substituteDrugFormulationId = "p_substitute_drug_formulation_id"
    }
}

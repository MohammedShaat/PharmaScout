//
//  PharmacyStaffMember+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import Foundation

extension PharmacyStaffMember {
    static let samples = [
        PharmacyStaffMember(
            id: "a1f3c7e2-8b45-4d91-9c26-5e7a103b6842",
            userInfo: .samples[0],
            pharmacyId: Pharmacy.samples[0].id,
            role: .owner,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "b6e2d9f4-3178-45a0-8c53-7f1b926d8045",
            userInfo: .samples[1],
            pharmacyId: Pharmacy.samples[0].id,
            role: .employee,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "c8a1f5d3-6249-4e70-b216-9d3f7a8c1052",
            userInfo: .samples[2],
            pharmacyId: Pharmacy.samples[0].id,
            role: .employee,
            status: .pending
        ),
        PharmacyStaffMember(
            id: "d4f9b2e7-1536-48c1-a805-6e7a3d9f2148",
            userInfo: .samples[3],
            pharmacyId: Pharmacy.samples[1].id,
            role: .employee,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "e7c3a9f1-4825-4d60-b217-8f5e1c6a9034",
            userInfo: .samples[4],
            pharmacyId: Pharmacy.samples[1].id,
            role: .employee,
            status: .rejected
        ),
        PharmacyStaffMember(
            id: "f2a6d8c4-7931-45e0-b528-1c7f9a3d6042",
            userInfo: .samples[5],
            pharmacyId: Pharmacy.samples[1].id,
            role: .employee,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "19e5b7c2-3468-4a91-8d70-5f2c6e1a9043",
            userInfo: .samples[6],
            pharmacyId: Pharmacy.samples[2].id,
            role: .employee,
            status: .pending
        ),
        PharmacyStaffMember(
            id: "2c8f4a6e-5173-49b0-a126-7d5e3c9f8041",
            userInfo: .samples[7],
            pharmacyId: Pharmacy.samples[2].id,
            role: .employee,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "3d7a1e9c-6254-48f0-b813-5c2e6a9d7047",
            userInfo: .samples[8],
            pharmacyId: Pharmacy.samples[2].id,
            role: .employee,
            status: .approved
        ),
        PharmacyStaffMember(
            id: "4e9c2b7f-8315-46a0-d924-1f6e8c3a7052",
            userInfo: .samples[9],
            pharmacyId: Pharmacy.samples[2].id,
            role: .employee,
            status: .rejected
        )
    ]
}

//
//  StaffMembership+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import Foundation

extension StaffMembership {
    static let samples = [
        StaffMembership(
            staffId: UUID().uuidString,
            pharmacyId: Pharmacy.samples[0].id,
            role: .owner,
            staffStatus: .approved,
            pharmacyStatus: .approved
        ),
        
        StaffMembership(
            staffId: UUID().uuidString,
            pharmacyId: Pharmacy.samples[0].id,
            role: .employee,
            staffStatus: .approved,
            pharmacyStatus: .approved
        )
    ]
}

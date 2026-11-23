//
//  StaffMembershipInitilization.swift
//  PharmaScout
//
//  Created by Mohammed on 11/23/26.
//


import Testing
@testable import PharmaScout
import Foundation

func makeMembership(
    role: PharmacyStaffRole,
    staffStatus: PharmacyStaffStatus,
    pharmacyStatus: PharmacyStatus,
    pharmacyRejectionReason: String?,
    staffRejectionReason: String?
) -> StaffMembership {
    StaffMembership(
        staffId: UUID().uuidString,
        pharmacyId: UUID().uuidString,
        role: role,
        staffStatus: staffStatus,
        pharmacyStatus: pharmacyStatus,
        pharmacyRejectionReason: pharmacyRejectionReason,
        staffRejectionReason: staffRejectionReason
    )
}
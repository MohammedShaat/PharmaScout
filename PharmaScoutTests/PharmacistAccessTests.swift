//
//  PharmacistAccessTests.swift
//  PharmaScoutTests
//
//  Created by Mohammed on 11/22/26.
//

import Testing
@testable import PharmaScout
import Foundation



@MainActor
struct PharmacistAccessTests {
    
    struct Case {
        let role: PharmacyStaffRole
        let staffStatus: PharmacyStaffStatus
        let pharmacyStatus: PharmacyStatus
        let expected: PharmacistAccess
    }
    
    static let cases: [Case] = [
        // Owner on an approved pharmacy has full access regardless of their status
        .init(role: .owner, staffStatus: .approved, pharmacyStatus: .approved, expected: .full(role: .owner)),
        .init(role: .owner, staffStatus: .pending, pharmacyStatus: .approved, expected: .full(role: .owner)),
        
        // Employee on an approved pharmacy has access depending on their status
        .init(role: .employee, staffStatus: .approved, pharmacyStatus: .approved, expected: .full(role: .employee)),
        .init(role: .employee, staffStatus: .pending, pharmacyStatus: .approved, expected: .restricted(role: .employee, reason: .membershipPending)),
        .init(role: .employee, staffStatus: .rejected, pharmacyStatus: .approved, expected: .restricted(role: .employee, reason: .membershipRejected(reason: "Staff reason"))),
        .init(role: .employee, staffStatus: .suspended, pharmacyStatus: .approved, expected: .restricted(role: .employee, reason: .membershipSuspended)),
        
        // Otherwise, pharmacy status wins
        .init(role: .owner, staffStatus: .approved, pharmacyStatus: .pending, expected: .restricted(role: .owner, reason: .pharmacyPending)),
        .init(role: .owner, staffStatus: .approved, pharmacyStatus: .closed, expected: .restricted(role: .owner, reason: .pharmacyClosed)),
        .init(role: .employee, staffStatus: .approved, pharmacyStatus: .suspended, expected: .restricted(role: .employee, reason: .pharmacySuspended))
    ]

    @Test("Membership has the right access")
    func access() async throws {
        for c in Self.cases {
            let membership = makeMembership(role: c.role, staffStatus: c.staffStatus, pharmacyStatus: c.pharmacyStatus, pharmacyRejectionReason: "Pharmacy reason", staffRejectionReason: "Staff reason")
            
            #expect(PharmacistAccess(membership: membership) == c.expected)
        }
    }

}

@MainActor
struct PharmacistCapabilityTests {
    
    struct Case {
        let access: PharmacistAccess
        let expected: Set<PharmacistCapability>
    }
    
    static let cases: [Case] = [
        // Full access
        .init(
            access: .full(role: .owner),
            expected: Set(PharmacistCapability.allCases).subtracting([.joinAnotherPharmacy])
        ),
        .init(
            access: .full(role: .employee),
            expected: [.viewPharmacy, .respondToInquiry]
        ),
        
        // Restricted owner
        .init(
            access: .restricted(role: .owner, reason: .membershipPending),
            expected: [.viewPharmacy, .editPharmacy, .closePharmacy]
        ),
        .init(
            access: .restricted(role: .owner, reason: .pharmacySuspended),
            expected: [.viewPharmacy, .editPharmacy, .closePharmacy]
        ),
        .init(
            access: .restricted(role: .owner, reason: .pharmacyClosed),
            expected: [.joinAnotherPharmacy]
        ),
        
        // Restricted employee
        .init(
            access: .restricted(role: .employee, reason: .membershipPending),
            expected: []
        ),
        .init(
            access: .restricted(role: .employee, reason: .pharmacySuspended),
            expected: []
        ),
        .init(
            access: .restricted(role: .employee, reason: .membershipRejected(reason: nil)),
            expected: [.joinAnotherPharmacy]
        ),
        .init(
            access: .restricted(role: .employee, reason: .pharmacyClosed),
            expected: [.joinAnotherPharmacy]
        )
    ]
    
    @Test("Capabilites match the access rules")
    func capabilities() {
        for c in Self.cases {
            let granted = Set(PharmacistCapability.allCases.filter { c.access.can($0) })
            #expect(granted == c.expected)
        }
    }
}

@MainActor
struct PharmacistTabsVisibility {
    private func visibleTabs(for access: PharmacistAccess) -> Set<PharmacistTab> {
        let allTabs: [PharmacistTab] = [.home, .inquiries, .pharmacy, .analytics, .profile]
        return Set(allTabs.filter { access.canAccess($0) })
    }
    
    @Test func fullOwnerSeesAllTabs() {
        let expectedTabs = Set(PharmacistTab.allCases)
        #expect(visibleTabs(for: .full(role: .owner)) == expectedTabs)
    }
    
    @Test func fullEmployeeHasNoAnalytics() {
        let expectedTabs = Set(PharmacistTab.allCases).subtracting([.analytics])
        #expect(visibleTabs(for: .full(role: .employee)) == expectedTabs)
    }
    
    @Test func restrictedOwnerHasNoInquiriesOrAnalytics() {
        let expectedTabs = Set(PharmacistTab.allCases).subtracting([.analytics, .inquiries])
        #expect(visibleTabs(for: .restricted(role: .owner, reason: .pharmacySuspended)) == expectedTabs)
    }
}

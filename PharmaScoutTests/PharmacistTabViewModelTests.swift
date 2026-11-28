//
//  PharmacistTabViewModelTests.swift
//  PharmaScoutTests
//
//  Created by Mohammed on 11/23/26.
//

import Testing
@testable import PharmaScout

@MainActor
struct PharmacistTabViewModelTests {
    private func makeVM(role: PharmacyStaffRole, staffStatus: PharmacyStaffStatus, pharmacyStatus: PharmacyStatus,) -> PharmacistTabViewModel {
        PharmacistTabViewModel(
            staffMembership: makeMembership(
                role: role,
                staffStatus: staffStatus,
                pharmacyStatus: pharmacyStatus,
                pharmacyRejectionReason: nil,
                staffRejectionReason: nil
            )
        )
    }
    
    
    @Test func `notification opens inquiries tab for full access`() async throws {
        let vm = makeVM(role: .owner, staffStatus: .approved, pharmacyStatus: .approved)
        vm.selectedTab = .home
        vm.handle(.inquiries(pharmacyId: "pharmacy-1"))
        #expect(vm.selectedTab == .inquiries)
    }

    @Test func `notification doesn't open inquiries tab for restricted access`() async throws {
        let vm = makeVM(role: .owner, staffStatus: .approved, pharmacyStatus: .suspended)
        vm.selectedTab = .home
        vm.handle(.inquiries(pharmacyId: "pharmacy-1"))
        #expect(vm.selectedTab != .inquiries)
    }
    
    @Test func `StaffMembership change recomputes access`() async throws {
        let vm = makeVM(role: .employee, staffStatus: .pending, pharmacyStatus: .approved)
        #expect(vm.access == .restricted(role: .employee, reason: .membershipPending))
        
        let newMembership = makeMembership(role: .employee, staffStatus: .approved, pharmacyStatus: .approved, pharmacyRejectionReason: nil, staffRejectionReason: nil)
        vm.onStaffMembershipChanged(newMembership)
        #expect(vm.access == .full(role: .employee))
    }
}

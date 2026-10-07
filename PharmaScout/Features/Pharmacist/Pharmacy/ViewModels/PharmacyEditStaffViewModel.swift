//
//  PharmacyEditStaffViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

@Observable
class PharmacyEditStaffViewModel {
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    private let pharmacy: Pharmacy
    private let oldStaffMembers: [PharmacyStaffMember]
    var staffMembers: [PharmacyStaffMember]
    
    var deletedStaffMemberIds: [String] = []
    
    var canUpdate: Bool { isStaffValid() }
    
    private(set) var loadingState = LoadingState()
    
    init(authService: AuthService, pharmacyService: PharmacyService, pharmacy: Pharmacy, staffMembers: [PharmacyStaffMember]) {
        self.authService = authService
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
//        self.oldStaffMembers = staffMembers
//        self.staffMembers = staffMembers
        
        let staffMembersExceptCurrentUser = staffMembers.filter { member in
            member.userInfo.id != authService.authSession?.user.id
        }
        self.oldStaffMembers = staffMembersExceptCurrentUser
        self.staffMembers = staffMembersExceptCurrentUser
    }
    
    func updateStaff(onSuccess: () -> Void) async {
        guard canUpdate else {
            print("Pharmacy working hours are invalid")
            return
        }
        
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            let updateStaffRequest = UpdatePharmacyStaffRequest(
                staffMembers: staffMembers.map(UpdatePharmacyStaffMember.init)
            )
            async let updateStaffMembers = pharmacyService.updateStaffMembers(request: updateStaffRequest)

            async let deleteStaffMembers = pharmacyService.deleteStaffMembers(ids: deletedStaffMemberIds)
            
            _ = try await (updateStaffMembers, deleteStaffMembers)
            
            onSuccess()
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy staff members\n", error)
        }
    }
    
    func addStaffMember() {
        
    }
    
    func deleteStaffMember(_ staffMember: PharmacyStaffMember) {
        staffMembers.removeAll { $0.id == staffMember.id }
        deletedStaffMemberIds.append(staffMember.id)
    }
}

extension PharmacyEditStaffViewModel {
    private func isStaffValid() -> Bool {
        Set(oldStaffMembers) != Set(staffMembers)
    }
}


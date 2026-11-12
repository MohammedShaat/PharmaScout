//
//  PharmacyEditStaffViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

@Observable
class PharmacyEditStaffViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacy: Pharmacy
    private(set) var staffMembers: [PharmacyStaffMember]
    
    var loadingState = LoadingState()
    var memberIdLoading: String?
    
    init(userId: String, pharmacyService: PharmacyService, pharmacy: Pharmacy, staffMembers: [PharmacyStaffMember]) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
        
        self.staffMembers = staffMembers
    }
    
    func updateMember(memberId: String, action: PharmacyStaffAction) async {
        loadingState.startLoading()
        memberIdLoading = memberId
        defer {
            loadingState.stopLoading()
            memberIdLoading = nil
        }
        
        do {
            let updateStaffRequest = ManagePharmacyStaffMemberRequest(
                staffId: memberId, action: action
            )
            try await pharmacyService.manageStaffMember(request: updateStaffRequest)
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy staff member\n", error)
        }
    }
    
    func listenToStaffChanges() async {
        do {
            try await changesListener(
                needsCatchup: true,
                realtimeStream: { try await pharmacyService.subscribeToStaffChanges(for: pharmacy.id) },
                trigger: { await loadStaff(refresh: true) }
            )
        } catch {
            print("Failed to subscribe to staff hours changes\n", error)
        }
    }
    
    private func loadStaff(refresh: Bool = false) async {
        loadingState.startLoading(refresh: refresh)
        defer { loadingState.stopLoading() }
        
        do {
            staffMembers = try await pharmacyService.getStaff(for: pharmacy.id)

        } catch {
            loadingState.fail(error)
            print("Failed to get pharmacy staff\n", error)
        }
    }
}

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
    private let pharmacyId: String
    private(set) var staffMembers: [PharmacyStaffMember]?
    
    var memberIdLoading: String?
    var updateLoadingState = LoadingState()
    var staffLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    private var hasFinishedFirstLoading: Bool = false
    
    init(userId: String, pharmacyService: PharmacyService, pharmacyId: String, staffMembers: [PharmacyStaffMember]?) {
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
        self.staffMembers = staffMembers
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadStaff(refresh: staffMembers != nil)
            hasFinishedFirstLoading = true
        }
    }
    
    func refresh() async {
        await loadStaff(refresh: true)
    }
    
    func updateMember(memberId: String, action: PharmacyStaffAction) async {
        updateLoadingState.startLoading()
        memberIdLoading = memberId
        defer {
            updateLoadingState.stopLoading()
            memberIdLoading = nil
        }
        
        do {
            let updateStaffRequest = ManagePharmacyStaffMemberRequest(
                staffId: memberId, action: action
            )
            try await pharmacyService.manageStaffMember(request: updateStaffRequest)
            
        } catch {
            updateLoadingState.fail(error)
            print("Failed to update pharmacy staff member\n", error)
        }
    }
    
    func listenToStaffChanges() async {
        do {
            try await changesListener(
                needsCatchup: hasFinishedFirstLoading,
                realtimeStream: { try await pharmacyService.subscribeToStaffChanges(for: pharmacyId) },
                trigger: refresh
            )
        } catch {
            print("Failed to subscribe to staff hours changes\n", error)
        }
    }
    
    private func loadStaff(refresh: Bool = false) async {
        staffLoadingState.startLoading(refresh: refresh)
        defer { staffLoadingState.stopLoading() }
        
        do {
            staffMembers = try await pharmacyService.getStaff(for: pharmacyId)

        } catch {
            staffLoadingState.fail(error)
            print("Failed to get pharmacy staff\n", error)
        }
    }
}

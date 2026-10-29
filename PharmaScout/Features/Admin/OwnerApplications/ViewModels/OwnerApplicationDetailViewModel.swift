//
//  OwnerApplicationDetailViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import Foundation

@Observable
class OwnerApplicationDetailViewModel {
    private let ownerApplicationService: OwnerApplicationService
    let  ownerApplicationId: String
    private(set) var ownerApplication: OwnerApplication?
    
    var canRevoke: Bool {
        ownerApplication?.status == .issued
    }
    var canReview: Bool {
        ownerApplication?.status == .pending
    }
    
    var approve: Bool = true
    
    private(set) var ownerApplicationLoadingState = LoadingState()
    private(set) var reviewLoadingState = LoadingState()
    private(set) var revokeLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService, ownerApplicationId: String, ownerApplication: OwnerApplication?) {
        self.ownerApplicationService = ownerApplicationService
        self.ownerApplicationId = ownerApplicationId
        self.ownerApplication = ownerApplication
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadApplicationIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await loadApplication(refresh: ownerApplication != nil)
        }
    }
    
    func refresh() async {
        await loadApplication(refresh: true)
    }
    
    func listenToChanges() async {
        do {
            try await changesListener(
                needsCatchup: hasStarted,
                realtimeStream: {
                    try await ownerApplicationService
                        .subscribeToOwnerApplicationChanges(for: ownerApplicationId)
                },
                trigger: refresh
            )
        } catch {
            print("Failed to subscribe to owner applications changes\n", error)
        }
    }
    
    private func loadApplication(refresh refreshing: Bool = false) async {
        ownerApplicationLoadingState.startLoading(refresh: refreshing)
        defer { ownerApplicationLoadingState.stopLoading() }
        
        do {
            ownerApplication = try await ownerApplicationService.getOwnerApplication(for: ownerApplicationId)
            
        } catch {
            ownerApplicationLoadingState.fail(error)
            print("Failed to load owner application\n", error)
        }
    }
    
    func review() async {
        reviewLoadingState.startLoading()
        defer { reviewLoadingState.stopLoading() }
        
        do {
            let request = ReviewOwnerApplicationRequest(applicationId: ownerApplicationId, approve: approve)
            try await ownerApplicationService.reviewOwnerApplication(request)
            
        } catch {
            reviewLoadingState.fail(error)
            print("Failed to review owner application\n", error)
        }
        
        await refresh()
    }
    
    func revoke() async {
        revokeLoadingState.startLoading()
        defer { revokeLoadingState.stopLoading() }
        
        do {
            try await ownerApplicationService.revokeOwnerApplication(for: ownerApplicationId)
            
        } catch {
            revokeLoadingState.fail(error)
            print("Failed to revoke owner application\n", error)
        }
        
        await refresh()
    }
}

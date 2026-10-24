//
//  PharmacyApplicationDetailViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

@Observable
class PharmacyApplicationDetailViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacyId: String
    private(set) var pharmacyApplication: PharmacyApplication?
    
    private(set) var contacts: [PharmacyContact] = []
    private(set) var workingHours: [WorkingHour] = []
    
    var rejectionReason: PharmacyRejectionReason?
    var customRejectionReason: String = ""
    
    var canReject: Bool {
        switch rejectionReason {
        case .other:
            isRejectionReasonValid(customRejectionReason)
        case nil:
            false
        default:
            true
        }
    }
    
    private(set) var activeReviewAction: ReviewAction?
    
    private(set) var pharmacyApplicationLoadingState = LoadingState()
    private(set) var contactLoadingState = LoadingState()
    private(set) var workingHoursLoadingState = LoadingState()
    private(set) var reviewLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService, pharmacyId: String, pharmacyApplication: PharmacyApplication?) {
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
        self.pharmacyApplication = pharmacyApplication
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadContactAndWorkingHoursIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            async let getPharmacyApplication = getPharmacyApplication(refresh: pharmacyApplication != nil)
            async let loadContact = loadContact()
            async let loadWorkingHours = loadWorkingHours()
            
            _ = await (getPharmacyApplication, loadContact, loadWorkingHours)
        }
    }
    
    func refresh() async {
        async let getPharmacyApplication = getPharmacyApplication(refresh: true)
        async let loadContact = loadContact(refresh: true)
        async let loadWorkingHours = loadWorkingHours(refresh: true)
        
        _ = await (getPharmacyApplication, loadContact, loadWorkingHours)
    }
    
    func approvePharmacy() async {
        await reviewPharmacy(action: .approve)
    }
    
    func rejectPharmacy() async {
        let reason = switch rejectionReason {
        case .other: customRejectionReason
        default: rejectionReason?.title
        }
        
        await reviewPharmacy(action: .reject, rejectionReason: reason)
    }
    
    private func reviewPharmacy(action: ReviewAction, rejectionReason: String? = nil) async {
        guard action == .approve || isRejectionReasonValid(rejectionReason) else {
            print("Rejection reason is not valid")
            return
        }
        
        activeReviewAction = action
        reviewLoadingState.startLoading()
        defer {
            reviewLoadingState.stopLoading()
            activeReviewAction = nil
        }
        
        do {
            let request = ReviewPharmacyRequest(
                pharmacyId: pharmacyId,
                approve: action == .approve,
                rejectionReason: action == .approve ? nil : rejectionReason
            )
            try await pharmacyService.reviewPharmacy(request)
            
        } catch {
            reviewLoadingState.fail(error)
            print("Failed to get pharmacy application\n", error)
        }
        
        await getPharmacyApplication()
    }
    
    private func getPharmacyApplication(refresh: Bool = false) async {
        pharmacyApplicationLoadingState.startLoading(refresh: refresh)
        defer { pharmacyApplicationLoadingState.stopLoading() }
        
        do {
            let newPharmacyApplication = try await pharmacyService.getPharmacyApplication(for: pharmacyId)
            pharmacyApplication = newPharmacyApplication
            
        } catch {
            pharmacyApplicationLoadingState.fail(error)
            print("Failed to get pharmacy application\n", error)
        }
    }
    
    private func loadContact(refresh: Bool = false) async {
        contactLoadingState.startLoading(refresh: refresh)
        defer { contactLoadingState.stopLoading() }
        
        do {
            contacts = try await pharmacyService.getContactInfo(for: pharmacyId)
            
        } catch {
            contactLoadingState.fail(error)
            print("Failed to get pharmacy contacts\n", error)
        }
    }
    
    private func loadWorkingHours(refresh: Bool = false) async {
        workingHoursLoadingState.startLoading(refresh: refresh)
        defer { workingHoursLoadingState.stopLoading() }
        
        do {
            workingHours = try await pharmacyService.getWorkingHours(for: pharmacyId)

        } catch {
            workingHoursLoadingState.fail(error)
            print("Failed to get pharmacy working hours\n", error)
        }
    }
}

extension PharmacyApplicationDetailViewModel {
    private func isRejectionReasonValid(_ reason: String?) -> Bool {
        guard let reason else { return false }
        
        return reason.count >= AppConstants.Validation.minRejectionReasonLength
    }
}

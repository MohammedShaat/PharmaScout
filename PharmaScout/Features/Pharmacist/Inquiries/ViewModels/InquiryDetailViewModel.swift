//
//  InquiryDetailViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

@Observable
class InquiryDetailViewModel {
    private let inquiryService: InquiryService
    private(set) var inquiryId: String
    private(set) var inquiry: Inquiry?

    private(set) var canCanResponse: Bool = false
    var responseIsValid: Bool {
        canCanResponse && response != nil && !(response == .substitute && substituteSelectedDrug == nil)
    }
    
    var response: InquiryResponse?
    private(set) var substituteSelectedDrug: SelectedDrug?

    private(set) var inquiryLoadingState = LoadingState()
    private(set) var responseLoadingState = LoadingState()
    private(set) var editEligibilityLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(inquiryService: InquiryService, inquiryId: String, inquiry: Inquiry?) {
        self.inquiryService = inquiryService
        self.inquiryId = inquiryId
        self.inquiry = inquiry
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            let refreshing = inquiry != nil
            async let getInquiry = getInquiry(refresh: refreshing)
            async let checkEditEligibility = checkEditEligibility()
            
            _ = await (getInquiry, checkEditEligibility)
        }
    }
    
    func refresh() async {
        async let refreshInquiry = getInquiry(refresh: true)
        async let checkEditEligibility = checkEditEligibility(refresh: true)
        
        _ = await (refreshInquiry, checkEditEligibility)
    }
    
    private func getInquiry(refresh: Bool = false) async {
        inquiryLoadingState.startLoading(refresh: refresh)
        defer { inquiryLoadingState.stopLoading() }
        
        do {
            inquiry = try await inquiryService.getInquiry(forId: inquiryId)
            
        } catch {
            inquiryLoadingState.fail(error)
            print("Failed to refresh inquiry: ", error)
        }
    }
    
    private func checkEditEligibility(refresh: Bool = false) async {
        editEligibilityLoadingState.startLoading(refresh: refresh)
        defer { editEligibilityLoadingState.stopLoading() }
        
        do {
            canCanResponse = try await inquiryService.canEditInquiry(forId: inquiryId)
            
        } catch {
            editEligibilityLoadingState.fail(error)
            print("Failed to check edit eligibility\n", error)
        }
    }
    
    func onSubstituteSelected(_ selectedDrug: SelectedDrug) {
        self.substituteSelectedDrug = selectedDrug
    }
    
    func sendResponse() async {
        guard let response,
                responseIsValid
        else {
            print("Response is in valid")
            return
        }
        
        responseLoadingState.startLoading(refresh: true)
        defer { responseLoadingState.stopLoading() }
        
        do {
            let params = RespondToInquiryParams(
                inquiryId: inquiryId,
                response: response,
                substituteDrugFormulationId: substituteSelectedDrug?.formulation.id
            )
            try await inquiryService.respondToInquiry(params)
            
        } catch {
            responseLoadingState.fail(error)
            print("Failed to respond to inquiry: ", error)
        }
        
        await refresh()
    }
}

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
    private(set) var inquiry: Inquiry

    private(set) var canCanResponse: Bool = false
    var responseIsValid: Bool {
        canCanResponse && response != nil && !(response == .substitute && substituteSelectedDrug == nil)
    }
    
    var response: InquiryResponse?
    private(set) var substituteSelectedDrug: SelectedDrug?

    private(set) var refreshInquiryLoadingState = LoadingState()
    private(set) var responseLoadingState = LoadingState()
    private(set) var editEligibilityLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(inquiryService: InquiryService, inquiry: Inquiry) {
        self.inquiryService = inquiryService
        self.inquiry = inquiry
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            async let refreshInquiry = refreshInquiry()
            async let checkEditEligibility = checkEditEligibility()
            
            _ = await (refreshInquiry, checkEditEligibility)
        }
    }
    
    func refresh() async {
        async let refreshInquiry = refreshInquiry()
        async let checkEditEligibility = checkEditEligibility(refresh: true)
        
        _ = await (refreshInquiry, checkEditEligibility)
    }
    
    private func refreshInquiry() async {
        refreshInquiryLoadingState.startLoading(refresh: true)
        defer { refreshInquiryLoadingState.stopLoading() }
        
        do {
            inquiry = try await inquiryService.getInquiry(forId: inquiry.id)
            
        } catch {
            refreshInquiryLoadingState.fail(error)
            print("Failed to refresh inquiry: ", error)
        }
    }
    
    private func checkEditEligibility(refresh: Bool = false) async {
        editEligibilityLoadingState.startLoading(refresh: refresh)
        defer { editEligibilityLoadingState.stopLoading() }
        
        do {
            canCanResponse = try await inquiryService.canEditInquiry(forId: inquiry.id)
            
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
                inquiryId: inquiry.id,
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

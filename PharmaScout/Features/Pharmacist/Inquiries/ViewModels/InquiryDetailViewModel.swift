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

    private(set) var refreshLoadingState = LoadingState()
    
    var canRespond: Bool { inquiry.status == .pending }
    var responseIsValid: Bool {
        canRespond && response != nil && !(response == .substitute && substituteSelectedDrug == nil)
    }
    var response: InquiryResponse?
    private(set) var responseLoadingState = LoadingState()
    private(set) var substituteSelectedDrug: SelectedDrug?
    
    init(inquiryService: InquiryService, inquiry: Inquiry) {
        self.inquiryService = inquiryService
        self.inquiry = inquiry
    }
    
    func refresh() async {
        refreshLoadingState.startLoading(refresh: true)
        defer { refreshLoadingState.stopLoading() }
        
        do {
            inquiry = try await inquiryService.getInquiry(forId: inquiry.id)
            
        } catch {
            refreshLoadingState.fail(error)
            print("Failed to refresh inquiry: ", error)
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

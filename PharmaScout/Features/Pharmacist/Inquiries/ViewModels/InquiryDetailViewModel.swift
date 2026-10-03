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
    var canRespond: Bool {
        inquiry.status == .pending
    }
    
    private(set) var respondLoadingState = LoadingState()
    var response: InquiryResponse?
    private(set) var substituteDrugFormulationId: String?
    private(set) var selectedDrug: SelectedDrug?
    
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
        self.selectedDrug = selectedDrug
        substituteDrugFormulationId = selectedDrug.formulation.id
    }
    
    func sendResponse() async {
        respondLoadingState.startLoading(refresh: true)
        defer { respondLoadingState.stopLoading() }
        
        do {
            #warning("edit response param")
            let params = RespondToInquiryParams(
                pharmacyId: inquiry.pharmacyId,
                response: .available,
                substituteDrugFormulationId: substituteDrugFormulationId
            )
            try await inquiryService.respondToInquiry(params)
            
        } catch {
            respondLoadingState.fail(error)
            print("Failed to respond to inquiry: ", error)
        }
    }
}

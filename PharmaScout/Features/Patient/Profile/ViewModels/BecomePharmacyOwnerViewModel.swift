//
//  BecomePharmacyOwnerViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class BecomePharmacyOwnerViewModel {
    private let ownerApplicationService: OwnerApplicationService
    
    var code: String = ""
    private(set) var applicationId: String?
    private(set) var codeSentSuccessfully: Bool = false
    
    let codeLength: Int  = AppConstants.Pharmacy.ownerApplicationCodeLength
    var canSend: Bool {
        code.trimmed.count == codeLength
    }
    
    private(set) var requestLoadingState = LoadingState()
    
    init(ownerApplicationService: OwnerApplicationService) {
        self.ownerApplicationService = ownerApplicationService
    }
    
    func sendRequest() async {
        guard canSend else {
            print("Code is invalid\n", code)
            return
        }
        
        codeSentSuccessfully = false
        requestLoadingState.startLoading()
        defer { requestLoadingState.stopLoading() }
        
        do {
            applicationId = try await ownerApplicationService.applyForPharmacyOwnership(code: code)
            codeSentSuccessfully = true
            
        } catch {
            requestLoadingState.fail(error)
            print("Failed to send code\n", error)
        }
    }
}

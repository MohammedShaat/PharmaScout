//
//  JoinPharmacyViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import Foundation

@Observable
class JoinPharmacyViewModel {
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    
    var code: String = ""
    
    let codeLength: Int  = AppConstants.Pharmacy.joinCodeLength
    var canSend: Bool {
        code.trimmed.count == codeLength
    }
    private(set) var codeSentSuccessfully: Bool = false
    private(set) var pharmacyId: String?
    
    private(set) var requestLoadingState = LoadingState()
    private(set) var authSessionLoadingState = LoadingState()
    
    init(authService: AuthService, pharmacyService: PharmacyService) {
        self.authService = authService
        self.pharmacyService = pharmacyService
    }
    
    func sendRequest() async {
        guard canSend else {
            print("Code is invalid\n", code)
            return
        }
        
        requestLoadingState.startLoading()
        codeSentSuccessfully = false
        defer { requestLoadingState.stopLoading() }
        
        do {
            pharmacyId = try await pharmacyService.joinPharmacy(code: code)
            codeSentSuccessfully = true
            
        } catch {
            requestLoadingState.fail(error)
            print("Failed to send code\n", error)
        }
    }
    
    func refresh() async {
        await refreshAuthSession()
    }
    
    private func refreshAuthSession() async {
        authSessionLoadingState.startLoading(refresh: true)
        defer { authSessionLoadingState.stopLoading() }
        
        do {
            try await authService.refreshAuthSession()
            
        } catch {
            authSessionLoadingState.fail(error)
            print("Failed to refresh auth session\n", error)
        }
    }
}

//
//  PharmacistProfileViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

@Observable
class PharmacistProfileViewModel {
    private let pharmacyService: PharmacyService
    
    var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService) {
        self.pharmacyService = pharmacyService
    }
    
    func closePharmacy() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            try await pharmacyService.closePharmacy()
            
        } catch {
            loadingState.fail(error)
            print("Failed to close pharmacy\n", error)
        }
    }
}

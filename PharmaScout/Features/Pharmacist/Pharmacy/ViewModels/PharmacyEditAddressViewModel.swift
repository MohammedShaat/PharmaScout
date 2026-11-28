//
//  PharmacyEditAddressViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import Foundation

@Observable
class PharmacyEditAddressViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacy: Pharmacy
    
    var name: String = ""
    var address: String = ""
    
    var canUpdate: Bool {
        name.count >= 3 && address.count >= 3
        && (name != pharmacy.name || address != pharmacy.address)
    }
    
    private(set) var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
        self.name = pharmacy.name
        self.address = pharmacy.address
    }
    
    func updatePharmacy(onSuccess: () -> Void) async {
        guard canUpdate else {
            print("Pharmacy ifno is invalid or not new")
            return
        }
        
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            let request = UpdatePharmacyRequest(
                name: name,
                address: address
            )
            try await pharmacyService.updatePharmacy(for: pharmacy.id, request: request)
            onSuccess()
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy\n", error)
        }
    }
}

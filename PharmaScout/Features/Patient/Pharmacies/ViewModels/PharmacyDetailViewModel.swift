//
//  PharmacyDetailViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import Foundation

@Observable
class PharmacyDetailViewModel {
    private let pharmacyService: PharmacyService
    private(set) var pharmacy: Pharmacy
    
    private(set) var contacts: [PharmacyContact] = []
    private(set) var workingHours: [WorkingHour] = []
    
    private(set) var contactLoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    private(set) var workingHoursLoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
    }
    
    func loadContact() async {
        contactLoadingState.startLoading()
        defer { contactLoadingState.stopLoading() }
        
        do {
            contacts = try await pharmacyService.getContactInfo(for: pharmacy.id)
            
        } catch {
            print("Failed to get pharmacy contacts\n", error)
        }
    }
    
    func loadWorkingHours() async {
        workingHoursLoadingState.startLoading()
        defer { workingHoursLoadingState.stopLoading() }
        
        do {
            workingHours = try await pharmacyService.getWorkingHours(for: pharmacy.id)

        } catch {
            print("Failed to get pharmacy working hours\n", error)
        }
    }
}

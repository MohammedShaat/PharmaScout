//
//  OwnerApplicantHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import Foundation

@Observable
class CreatePharmacyViewModel {
    private let pharmacyService: PharmacyService
    private let ownerApplicationService: OwnerApplicationService
    
    var name: String = ""
    var address: String = ""
    var coordinate: Coordinate?
    var timezone: String = TimeZone.current.identifier
    var workingHours: [WorkingHour] = []
    var contacts: [PharmacyContact] = []
    
    private var addressChangedByUser: Bool = false
    
    var canCreatePharmacy: Bool { isDataValid() }
    
    var showSuccessMessage: Bool = false
    
    private(set) var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService, ownerApplicationService: OwnerApplicationService) {
        self.pharmacyService = pharmacyService
        self.ownerApplicationService = ownerApplicationService
    }
    
    func onLocationConfirmed(_ newCoordinate: Coordinate, _ resolvedPlace: ResolvedPlace) {
        coordinate = newCoordinate
        
        if !addressChangedByUser,
           let suggestedAddress = resolvedPlace.suggestedAddress {
            address = suggestedAddress
        }
        if let resolvedTimezone =  resolvedPlace.timeZone {
            timezone = resolvedTimezone.identifier
        }
    }
    
    func onAddressChangedByUser() {
        addressChangedByUser = true
    }
    
    func onWorkingHoursEdited(_ editedWoringHours: [WorkingHour]) {
        workingHours = editedWoringHours
    }
    
    func onContactsEdited(_ editedContacts: [PharmacyContact]) {
        contacts = editedContacts
    }
    
    func createPharmacy() async {
        guard canCreatePharmacy,
              let coordinate else {
            print("Data is not valid")
            return
        }
        
        showSuccessMessage = false
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            let request = CreatePharmacyRequest(
                name: name,
                address: address,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                timezone: timezone,
                hours: workingHours,
                contacts: contacts
            )
            _ = try await pharmacyService.createPharmacy(request)
            
            showSuccessMessage = true
            
        } catch {
            loadingState.fail(error)
            print("Failed to create pharmacy\n", error)
        }
    }
    
    func onSuccessMessageDismissed() {
        clear()
    }
    
    private func clear() {
        name = ""
        address = ""
        coordinate = nil
        workingHours.removeAll()
        contacts.removeAll()
        showSuccessMessage = false
    }
}

extension CreatePharmacyViewModel {
    private func isDataValid() -> Bool {
        name.trimmed.count >= 3
        && address.trimmed.count >= 6
        && coordinate != nil
        && workingHours.count >= 1
    }
}

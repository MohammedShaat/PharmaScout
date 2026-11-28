//
//  PharmacyEditContactViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import Foundation

@Observable
class PharmacyEditContactViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacy: Pharmacy
    var contacts: [PharmacyContact]
    
    var deletedContactIds: [String] = []
    
    var canUpdate: Bool { areContactsValid() }
    
    private(set) var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy, contacts: [PharmacyContact]) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
        self.contacts = contacts
    }
    
    func updateContacts(onSuccess: () -> Void) async {
        guard canUpdate else {
            print("Pharmacy contacts are invalid")
            return
        }
        
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            async let createOrUpdateContacts = pharmacyService.createOrUpdateContacts(contacts: contacts)
            async let deleteContacts = pharmacyService.deleteContacts(ids: deletedContactIds)
            
            _ = try await (createOrUpdateContacts, deleteContacts)
            
            onSuccess()
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy contacts\n", error)
        }
    }
    
    func addContact() {
        let newContact = PharmacyContact(
            id: UUID().uuidString,
            pharmacyId: pharmacy.id,
            title: "",
            type: .link,
            value: ""
        )
        contacts.append(newContact)
    }
    
    func deleteContact(_ contact: PharmacyContact) {
        contacts.removeAll { $0.id == contact.id }
        deletedContactIds.append(contact.id)
    }
}

extension PharmacyEditContactViewModel {
    private func areContactsValid() -> Bool {
        contacts.allSatisfy { $0.isValid }
    }
}

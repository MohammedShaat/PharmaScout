//
//  CreateOrEditContactsViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

@Observable
class CreateOrEditContactsViewModel {
    var contacts: [PharmacyContact]
    
    var canUpdate: Bool { areContactsValid() }
    
    private(set) var loadingState = LoadingState()
    
    init(contacts: [PharmacyContact]) {
        self.contacts = contacts
    }
    
    func updateContacts(onSuccess: () -> Void) {
        guard canUpdate else {
            print("Pharmacy contacts are invalid")
            return
        }
        
        onSuccess()
    }
    
    func addContact() {
        let newContact = PharmacyContact(
            id: UUID().uuidString,
            pharmacyId: "",
            title: "",
            type: .link,
            value: ""
        )
        contacts.append(newContact)
    }
    
    func deleteContact(_ contact: PharmacyContact) {
        contacts.removeAll { $0.id == contact.id }
    }
}

extension CreateOrEditContactsViewModel {
    private func areContactsValid() -> Bool {
        contacts.allSatisfy { $0.isValid }
    }
}


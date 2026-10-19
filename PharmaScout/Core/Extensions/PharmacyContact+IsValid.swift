//
//  PharmacyContact+IsValid.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

extension PharmacyContact {
    var isValid: Bool {
        title.count >= 3
        && value.count >= 3
        && typeMatchValue(type: type, value: value)
    }
    
    private func typeMatchValue(type: ContactType, value: String) -> Bool {
        switch type {
        case .number:
            Validation.isPhoneNumberValid(value)
        case .link:
            Validation.isURLValid(value)
        case .email:
            Validation.isEmailValid(value)
        }
    }
}

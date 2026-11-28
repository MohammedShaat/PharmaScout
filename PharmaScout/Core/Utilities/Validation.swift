//
//  Validation.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import Foundation

enum Validation {
    static func isEmailValid(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        password.count >= 8
    }
    
    static func isURLValid(_ url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        
        return url.scheme != nil && url.host != nil
    }
    
    static func isPhoneNumberValid(_ number: String) -> Bool {
        let pattern = #"^\+?[0-9]{7,15}$"#
        
        return number.range(of: pattern, options: .regularExpression) != nil
    }
}

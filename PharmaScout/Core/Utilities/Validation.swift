//
//  Validation.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import Foundation

struct Validation {
    private init() {}
    
    static func isEmailValid(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        password.count >= 8
    }
}

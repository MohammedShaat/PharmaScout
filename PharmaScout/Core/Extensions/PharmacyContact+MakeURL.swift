//
//  PharmacyContact+MakeURL.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import Foundation

extension PharmacyContact {
    func makeURL() -> URL? {
        var components = URLComponents()
        
        switch type {
        case .number:
            components.scheme = "tel"
            components.path = value
        case .email:
            components.scheme = "mailto"
            components.path = value
        case .link:
            return URL(string: value)
        }

        return components.url
    }
}

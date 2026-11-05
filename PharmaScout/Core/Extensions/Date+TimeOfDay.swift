//
//  Date+TimeOfDay.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import Foundation

extension Date {
    var timeOfDay: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: self)

        return switch hour {
        case 5..<12: .morning
        case 12..<18: .afternoon
        default: .evening
        }
    }
}

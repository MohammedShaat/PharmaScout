//
//  Date+TimeOfDay.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import Foundation

extension Date {
    var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: self)

        let time =
            switch hour {
            case 5..<12: "morning"
            case 12..<18: "afternoon"
            default: "evening"
            }

        return time
    }
}

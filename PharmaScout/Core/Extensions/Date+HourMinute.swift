//
//  Date+HourMinute.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import Foundation

extension Date {
    var hourMinute: String {
        DateFormatters.hourMinute.string(from: self)
    }
}

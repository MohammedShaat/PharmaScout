//
//  Date+TimeString.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

extension Date {
    var timeString: String {
        DateFormatters.time.string(from: self)
    }
}

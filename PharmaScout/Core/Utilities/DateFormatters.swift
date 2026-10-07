//
//  DateFormatters.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

enum DateFormatters {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

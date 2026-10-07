//
//  Date+StartOfToday.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

extension Date {
    static var startOfToday: Date {
        Calendar.current.startOfDay(for: .now)
    }
}

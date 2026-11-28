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
    
    static var endOfToday: Date {
        Calendar.current.date(
            byAdding: .second,
            value: -1,
            to: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: startOfToday
            )!
        )!
    }
}

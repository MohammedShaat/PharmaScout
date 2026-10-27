//
//  Date+TimeInSeconds.swift
//  PharmaScout
//
//  Created by Mohammed on 10/27/26.
//

import Foundation

extension Date {
    var timeInSeconds: Int {
        let components = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: self
        )

        return (components.hour ?? 0) * 3600
            + (components.minute ?? 0) * 60
            + (components.second ?? 0)
    }

    static var startOfDaySeconds: Int { 0 }

    static var endOfDaySeconds: Int { 86_399 }
}

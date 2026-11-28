//
//  WorkingHour+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

private let open = Calendar.current.date(bySetting: .hour, value: 8, of: .now)!
private let close = Calendar.current.date(bySetting: .hour, value: 22, of: .now)!

extension WorkingHour {
    static let samples = (1...7).map { index in
        
        
        return WorkingHour(
            id: UUID().uuidString,
            day: .init(from: index),
            opensAt: open,
            closesAt: close
        )
    } + [
        WorkingHour(
            id: UUID().uuidString,
            day: .init(from: 1),
            opensAt: open,
            closesAt: close
        )
    ]
}

//
//  WorkingHour+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

extension WorkingHour {
    static let samples = Pharmacy.samples.map { pharmacy in
        (1...7).map { index in
            let opensAt = Calendar.current.date(bySetting: .hour, value: 8, of: .now)!
            let closesAt = Calendar.current.date(bySetting: .hour, value: 22, of: .now)!
            
            return WorkingHour(
                id: UUID().uuidString,
                day: .init(from: index),
                opensAt: opensAt,
                closesAt: closesAt
            )
        }
    }
    .flatMap { $0 }
}

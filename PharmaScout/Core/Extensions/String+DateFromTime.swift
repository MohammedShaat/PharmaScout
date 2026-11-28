//
//  String+DateFromTime.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

extension String {
    func toDateFromTime() -> Date? {
        DateFormatters.time.date(from: self)
    }
}

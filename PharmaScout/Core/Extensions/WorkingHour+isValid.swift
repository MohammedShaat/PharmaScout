//
//  IsWorkingHourValid.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

extension WorkingHour {
    var isValid: Bool {
        opensAt < closesAt
    }
}

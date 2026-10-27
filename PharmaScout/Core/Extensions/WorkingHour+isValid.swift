//
//  IsWorkingHourValid.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

extension WorkingHour {
    var validationError: WorkingHourError? {
        let openingSec = opensAt.timeInSeconds
        let closingSec = closesAt.timeInSeconds
        
        let regular = openingSec < closingSec
        let work24 = openingSec == Date.startOfDaySeconds && closingSec == Date.endOfDaySeconds
        let overnight = openingSec > closingSec && closingSec == Date.endOfDaySeconds
        
        if regular || work24 || overnight { return nil }
        
        if openingSec == closingSec {
            return .invalidEqualHours
        }
        
        return .invalidOvernightHours
    }
    
    var isValid: Bool {
        validationError == nil
    }
}

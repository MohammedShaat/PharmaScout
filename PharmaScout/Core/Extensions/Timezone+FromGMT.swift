//
//  Timezone+FromGMT.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import Foundation

extension TimeZone {
    var timeFromGMT: String {
        let seconds = secondsFromGMT()
        let hours = seconds / 3_600
        let minutes = (seconds % 3_600) / 60
        
        return String(format: "UTC%+03d:%02d", hours, minutes)
    }
}

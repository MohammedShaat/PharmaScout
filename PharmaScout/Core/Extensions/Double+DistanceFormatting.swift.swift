//
//  Double+DistanceFormatting.swift.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation


extension Double {
    var formattedDistance: String {
        let numberFormat = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))

        if self < 1_000 {
            return formatted(numberFormat) + " m"
        } else {
            return meterToKilometer.formatted(numberFormat) + " km"
        }
    }
}

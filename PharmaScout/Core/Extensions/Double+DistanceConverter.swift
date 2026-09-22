//
//  Double+DistanceConverter.swift
//  PharmaScout
//
//  Created by Mohammed on 9/16/26.
//

import Foundation

extension Double {
    var meterToKilometer: Double { self / 1_000 }
    
    var kilometerToMeter: Double { self * 1_000 }
}

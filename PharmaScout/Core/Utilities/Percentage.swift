//
//  Percentage.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import Foundation

func percentage(_ value: Double, of total: Double) -> Int {
    guard total != 0 else { return 0 }
    let percentage = (value / total) * 100
    return Int(percentage.rounded())
}

func percentage(_ value: Int, of total: Int) -> Int {
    percentage(Double(value), of: Double(total))
}

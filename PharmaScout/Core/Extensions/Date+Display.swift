//
//  Date+Display.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

extension Date {
    var formattedDateTime: String {
        formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedTime: String {
        formatted(date: .omitted, time: .shortened)
    }
}


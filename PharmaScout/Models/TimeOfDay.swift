//
//  TimeOfDay.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import Foundation

enum TimeOfDay {
    case morning
    case afternoon
    case evening
    
    var title: String {
        switch self {
        case .morning: "Morning"
        case .afternoon: "Afternoon"
        case .evening: "Evening"
        }
    }
}

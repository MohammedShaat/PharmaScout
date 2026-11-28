//
//  AnalyticsPeriod.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import Foundation

enum AnalyticsPeriod: Int, CaseIterable, Identifiable {
    case sevenDays = 7
    case thirtyDays = 30
    case ninetyDays = 90
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .sevenDays: "7 days"
        case .thirtyDays: "30 days"
        case .ninetyDays: "90 days"
        }
    }
}

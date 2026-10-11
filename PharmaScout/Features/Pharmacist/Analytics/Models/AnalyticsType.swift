//
//  AnalyticsType.swift
//  PharmaScout
//
//  Created by Mohammed on 10/11/26.
//

import Foundation

enum AnalyticsType: String, CaseIterable, Identifiable {
    case pharmacySearch = "pharmacy_search"
    case regional = "regional"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .pharmacySearch: "Pharmacy Search"
        case .regional: "Regional"
        }
    }
}

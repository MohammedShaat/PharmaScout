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
}

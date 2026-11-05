//
//  SubmittedSearch.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import Foundation

struct SubmittedSearch: Identifiable, Hashable {
    let id: String
    let distanceMeters: Double
    let drugs: [SelectedDrug]
}

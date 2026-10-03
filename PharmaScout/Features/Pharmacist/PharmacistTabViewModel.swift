//
//  PharmacistTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

@Observable
class PharmacistTabViewModel {
    var selectedTab: PharmacistTab = .home
}

enum PharmacistTab {
    case home
    case inquiries
    case pharmacy
    case analytics
    case profile
}

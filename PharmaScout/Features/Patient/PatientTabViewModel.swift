//
//  PatientTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation
import SwiftUI

@Observable
class PatientTabViewModel {
    var selectedTab: PatientTab = .home
    var pharmacyPath = NavigationPath()
    var recentSearchsPath = NavigationPath()
    
    func navigateToSearchTab() {
        selectedTab = .search
    }
    
    func navigateToPharmaciesTab() {
        selectedTab = .pharmacies
    }
    
    func navigateToPharmacyDetailScreen(for pharmacy: Pharmacy) {
        pharmacyPath.append(PharmacyDestination.details(pharmacy))
        navigateToPharmaciesTab()
    }
    
    func navigateToRecentSearchesTab() {
        selectedTab = .recentSearches
    }
    
    func navigateToSearchDetailScreen(for search: Search) {
        recentSearchsPath.append(search)
        navigateToRecentSearchesTab()
    }
}

enum PatientTab {
    case home
    case search
    case recentSearches
    case pharmacies
    case profile
}

enum PharmacyDestination: Hashable {
    case details(Pharmacy)
    case map(Pharmacy)
}

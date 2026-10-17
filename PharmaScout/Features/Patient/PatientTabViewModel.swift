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
        navigateToPharmaciesTab()
        pharmacyPath = NavigationPath([PharmacyDestination.details(pharmacy)])
    }
    
    func navigateToRecentSearchesTab() {
        selectedTab = .recentSearches
    }
    
    func navigateToSearchDetailScreenBy(_ search: Search) {
        navigateToRecentSearchesTab()
        recentSearchsPath = NavigationPath([SearchDetailRoute(searchId: search.id, search: search)])
    }
    
    func navigateToSearchDetailScreenBy(_ searchId: String) {
        navigateToRecentSearchesTab()
        recentSearchsPath = NavigationPath([SearchDetailRoute(searchId: searchId)])
    }
    
    func handle(_ route: PatientNotificationRoute) {
        switch route {
        case .searchDetail(let searchId):
            navigateToSearchDetailScreenBy(searchId)
        }
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

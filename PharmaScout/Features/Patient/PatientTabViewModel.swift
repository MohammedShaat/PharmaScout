//
//  PatientTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class PatientTabViewModel {
    var selectedTab: PatientTab = .home
    var pharmacyPath: [PharmacyDestination] = []
    
    func navigateToSearchTab() {
        selectedTab = .search
    }
    
    func navigateToPharmaciesTab() {
        selectedTab = .pharmacies
    }
    
    func navigateToPharmacyDetailScreen(for pharmacy: Pharmacy) {
        pharmacyPath.append(.details(pharmacy))
        navigateToPharmaciesTab()
    }
}

enum PatientTab {
    case home
    case search
    case recent
    case pharmacies
    case profile
}

enum PharmacyDestination: Hashable {
    case details(Pharmacy)
    case map(Pharmacy)
}

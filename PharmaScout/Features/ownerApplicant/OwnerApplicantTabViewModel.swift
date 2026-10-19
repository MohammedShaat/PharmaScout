//
//  AdminTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class OwnerApplicantTabViewModel {
    private let ownerApplicationSummary: OwnerApplicationSummary
    
    var selectedTab: OwnerApplicantTab = .home
    var status: OwnerApplicationStatus { ownerApplicationSummary.status }
    
    init(ownerApplicationSummary: OwnerApplicationSummary) {
        self.ownerApplicationSummary = ownerApplicationSummary
    }
    
    func navigateToCreatePharmacyTab() {
        selectedTab = .createPharmacy
    }
}

enum OwnerApplicantTab {
    case home
    case createPharmacy
    case profile
}

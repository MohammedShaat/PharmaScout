//
//  PharmacistTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation
import SwiftUI

@Observable
class PharmacistTabViewModel {
    private let authService: AuthService
    var selectedTab: PharmacistTab = .home
    var inquiriesPath = NavigationPath()
    
    var authSession: AuthSession? {
        authService.authSession
    }
    var isAuthorized: Bool {
        authSession?.pharmacyStaff?.status == .approved
    }
    var isOwner: Bool {
        authSession?.pharmacyStaff?.role == .owner
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func navigateToInquiriesTab() {
        selectedTab = .inquiries
    }
    
    func navigateToInquiryDetailScreen(_ inquiry: Inquiry) {
        inquiriesPath.append(inquiry)
        navigateToInquiriesTab()
    }
}

enum PharmacistTab {
    case home
    case inquiries
    case pharmacy
    case analytics
    case profile
}

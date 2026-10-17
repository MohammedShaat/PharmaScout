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
    
    func navigateToInquiryDetailScreenBy(_ inquiry: Inquiry) {
        navigateToInquiriesTab()
        inquiriesPath = NavigationPath([InquiryDetailRoute(inquiryId: inquiry.id, inquiry: inquiry)])
    }
    
    func navigateToInquiryDetailScreenBy(_ inquiryId: String) {
        navigateToInquiriesTab()
        inquiriesPath = NavigationPath([InquiryDetailRoute(inquiryId: inquiryId)])
    }
    
    func handle(_ route: PharmacistNotificationRoute) {
        switch route {
        case .inquiries:
            navigateToInquiriesTab()
            
        case .inquiryDetail(let inquiryId):
            navigateToInquiryDetailScreenBy(inquiryId)
        }
    }
}

enum PharmacistTab {
    case home
    case inquiries
    case pharmacy
    case analytics
    case profile
}

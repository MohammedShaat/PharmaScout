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
    private let membership: StaffMembership
    var selectedTab: PharmacistTab = .home
    var inquiriesPath = NavigationPath()
    
    var isAuthorized: Bool {
        membership.staffStatus == .approved
    }
    var isOwner: Bool {
        membership.role == .owner
    }
    
    init(staffMembership: StaffMembership) {
        self.membership = staffMembership
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

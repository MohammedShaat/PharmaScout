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
    let membership: StaffMembership
    var selectedTab: PharmacistTab = .home
    var inquiriesPath = NavigationPath()
    
    var access: PharmacistAccess
    
    init(staffMembership: StaffMembership) {
        self.membership = staffMembership
        self.access = PharmacistAccess(membership: membership)
    }
    
    func navigateToInquiriesTab() {
        guard access.canAccess(.inquiries) else {
            print("Denied access to inquiries")
            return
        }
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

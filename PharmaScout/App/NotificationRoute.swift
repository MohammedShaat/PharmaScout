//
//  NotificationRoute.swift
//  PharmaScout
//
//  Created by Mohammed on 10/17/26.
//

import Foundation
import GoogleSignIn
import Supabase

enum NotificationRoute: Equatable {
    case patient(route: PatientNotificationRoute)
    case pahrmacist(route: PharmacistNotificationRoute)

    init?(userInfo: [AnyHashable: Any]) {
        switch userInfo[Payload.type] as? String {
            
        case Payload.TypeValue.searchContinuation,
            Payload.TypeValue.searchCompleted,
            Payload.TypeValue.itemFulfilled:
            guard let id = userInfo[Payload.searchId] as? String else { return nil }
            self = .patient(route: .searchDetail(searchId: id))
            
        case Payload.TypeValue.newInquiries:
            guard let id = userInfo[Payload.pharmacyId] as? String else { return nil }
            self = .pahrmacist(route: .inquiries(pharmacyId: id))
            
        case Payload.TypeValue.newInquiry:
            guard let id = userInfo[Payload.inquiryId] as? String else { return nil }
            self = .pahrmacist(route: .inquiryDetail(inquiryId: id))

        default:
            return nil
        }
    }
}

enum PatientNotificationRoute: Equatable {
    case searchDetail(searchId: String)
}

enum PharmacistNotificationRoute: Equatable {
    case inquiries(pharmacyId: String)
    case inquiryDetail(inquiryId: String)
}

extension NotificationRoute {
    enum Payload {
        // type
        static let type = "type"
        
        enum TypeValue {
            static let searchContinuation = "search_continuation"
            static let searchCompleted = "search_completed"
            static let itemFulfilled = "item_fulfilled"
            static let newInquiries = "new_inquiries"
            static let newInquiry = "new_inquiry"
        }
        
        // search continuation, search completed, item fulfilled
        static let searchId = "search_id"
        
        // new inquries
        static let pharmacyId = "pharmacy_id"
        
        // new inqury
        static let inquiryId = "inquiry_id"
    }
}

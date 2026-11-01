//
//  PharmacistAccess.swift
//  PharmaScout
//
//  Created by Mohammed on 10/24/26.
//

import Foundation

enum PharmacistCapability: CaseIterable {
    case respondToInquiry
    case editPharmacy
    case viewPharmacy
    case viewAnalytics
    case manageStaff
    case closePharmacy
    case joinAnotherPharmacy
}


enum PharmacistRestriction: Equatable {
    case pharmacyPending
    case pharmacyRejected(reason: String?)
    case pharmacySuspended
    case pharmacyClosed
    case membershipPending
    case membershipRejected(reason: String?)
    case membershipSuspended
}

extension PharmacistTab {
    var requiredCapability: PharmacistCapability? {
        switch self {
        case .home, .profile:
            nil
        case .inquiries:
            .respondToInquiry
        case .pharmacy:
            .viewPharmacy
        case .analytics:
            .viewAnalytics
        }
    }
}

enum PharmacistAccess {
    case full(role: PharmacyStaffRole)
    case restricted(role: PharmacyStaffRole, reason: PharmacistRestriction)
    
    init(membership: StaffMembership) {
        switch membership.pharmacyStatus {
        case .approved:
            if membership.isOwner {
                self = .full(role: membership.role)
            }
            else {
                switch membership.staffStatus {
                case .approved:
                    self = .full(role: membership.role)
                case .rejected:
                    self = .restricted(role: membership.role, reason: .membershipRejected(reason: membership.staffRejectionReason))
                case .pending:
                    self = .restricted(role: membership.role, reason: .membershipPending)
                case .suspended:
                    self = .restricted(role: membership.role, reason: .membershipSuspended)
                }
            }
            
        case .rejected:
            self = .restricted(role: membership.role, reason: .pharmacyRejected(reason: membership.pharmacyRejectionReason))
        case .pending:
            self = .restricted(role: membership.role, reason: .pharmacyPending)
        case .suspended:
            self = .restricted(role: membership.role, reason: .pharmacySuspended)
        case .closed:
            self = .restricted(role: membership.role, reason: .pharmacyClosed)
        }
    }
    
    func can(_ capability: PharmacistCapability) -> Bool {
        let fullAccessForOwner: [PharmacistCapability] = PharmacistCapability.allCases.filter { $0 != .joinAnotherPharmacy }
        let restrictedAccessForOwner: [PharmacistCapability] = [.viewPharmacy, .editPharmacy, .closePharmacy]
        let fullAccessForEmployee: [PharmacistCapability] = [.viewPharmacy, .respondToInquiry]
        let restrictedAccessForEmployee: [PharmacistCapability] = []
        
        switch self {
        case .full(let role):
            switch role {
            case .owner:
                return fullAccessForOwner.contains(capability)
            case .employee:
                return fullAccessForEmployee.contains(capability)
            }
            
        case .restricted(let role, let reason):
                var allowed: [PharmacistCapability]
                switch role {
                case .owner:    allowed = restrictedAccessForOwner
                case .employee: allowed = restrictedAccessForEmployee
                }

                if reason == .pharmacyClosed {
                    allowed.append(.joinAnotherPharmacy)
                    allowed.removeAll { $0 == .closePharmacy }
                }
                return allowed.contains(capability)
        }
    }
    
    func canAccess(_ tab: PharmacistTab) -> Bool {
        guard let requiredCapability = tab.requiredCapability else { return true }
        return can(requiredCapability)
    }
}


/*
 switch capablility {
 case .viewPharmacy:
     // Owner or approved employee with approved pharmacy
     membership.isOwner || (membership.isPharmacyApproved && membership.isStaffApproved)
 
 case .editPharmacy:
     // Owner can edit pharmacy regardless of pharmacy status to edit info in case of ownership appliation edit
     membership.isOwner
     
 case .manageEmployees:
     // Owner can manage employees while the pharmacy is approved
     membership.isPharmacyApproved && membership.isOwner
     
 case .respondToInquiry:
     // Approved staff can respond to inquiries while the pharmacy is approved
     membership.isPharmacyApproved && membership.isStaffApproved
     
 case .viewAnalytics:
     // Owner can view analytics while the pharmacy is approved
     membership.isPharmacyApproved && membership.isOwner
 }
 */

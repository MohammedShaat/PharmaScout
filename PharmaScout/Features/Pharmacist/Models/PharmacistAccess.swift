//
//  PharmacistAccess.swift
//  PharmaScout
//
//  Created by Mohammed on 10/24/26.
//

import Foundation

enum PharmacistCapability: Equatable, CaseIterable {
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

enum PharmacistAccess: Equatable {
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
            switch reason {
            case .pharmacyClosed, .membershipRejected:
                allowed.removeAll()
                allowed.append(.joinAnotherPharmacy)
            default: break
            }
            return allowed.contains(capability)
        }
    }
    
    func canAccess(_ tab: PharmacistTab) -> Bool {
        guard let requiredCapability = tab.requiredCapability else { return true }
        return can(requiredCapability)
    }
}

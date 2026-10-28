//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistRestrictedHomeScreen: View {
    let user: AppUser
    let role: PharmacyStaffRole
    let pharmacistRestriction: PharmacistRestriction
    
    @State private var vm = PharmacistRestrictedViewModel()
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Text(title)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    if let detail {
                        Text(detail)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
        }
    }
    
    
    private var headerSection: some View {
        GreetingHeaderView(user: user, hasUnreadNotifications: vm.hasUnreadNotifications)
    }
    
    private var isOwner: Bool { role == .owner }
    
    private var title: String {
            switch pharmacistRestriction {
            case .pharmacyPending:
                isOwner ? "Your pharmacy is pending approval." : "The pharmacy is awaiting approval."
            case .pharmacyRejected:
                isOwner ? "Your pharmacy application was rejected." : "The pharmacy application was rejected."
            case .pharmacySuspended:
                isOwner ? "Your pharmacy is suspended." : "The pharmacy is suspended."
            case .membershipPending:
                "Your request is pending. Waiting for the pharmacy owner’s approval."
            case .membershipRejected:
                "Your request was rejected."
            case .membershipSuspended:
                "You are suspended."
            }
        }

        private var detail: String? {
            switch pharmacistRestriction {
            case .pharmacyRejected(let reason), .membershipRejected(let reason): reason
            case .membershipPending: nil
            default: nil
            }
        }
}

#Preview {
    PharmacistRestrictedHomeScreen(
        user: .samples[0],
        role: .owner,
        pharmacistRestriction: .pharmacyPending,
    )
}

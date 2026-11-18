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
    
    var body: some View {
        CustomNavStack {
            CenteredScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    headerSection
                    Spacer()
                    
                    explanationSection
                    
                    if pharmacistRestriction == .pharmacyClosed {
                        anotherPharmacySection
                    }
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    
    private var headerSection: some View {
        GreetingHeaderView(firstName: user.firstName)
    }
    
    
    private var explanationSection: some View {
        ApplicationStatusView(
            title: title,
            mainIconSystemName: mainIconSystemName,
            mainIconColor: pharmacistRestriction.color,
            mainIconBgColor: pharmacistRestriction.bgColor,
            statusLabel: statusLabel,
            statusIconSystemName: statusIconSystemName,
            statusIconColor: pharmacistRestriction.color,
            statusIconBgColor: pharmacistRestriction.bgColor
        ) {
            if let reason {
                Text(reason)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.xLarge)
        .roundedBackground()
    }
    
    private var anotherPharmacySection: some View {
        DestinationSuggestionView(
            systemName: "person.badge.plus",
            title: "Want to work with another pharmacy or register your own?",
            destinationString: "Open your Profile and look under “Pharmacy”."
        )
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(background: .mintTint)
    }
    
    private var mainIconSystemName: String {
        switch pharmacistRestriction {
        case .membershipPending, .pharmacyPending: "hourglass"
        case .membershipRejected, .pharmacyRejected: "xmark.circle"
        case .membershipSuspended, .pharmacySuspended: "pause.circle"
        case .pharmacyClosed: "lock"
        }
    }
    
    private var statusLabel: String {
        switch pharmacistRestriction {
        case .membershipPending, .pharmacyPending: "Pending"
        case .membershipRejected, .pharmacyRejected: "Rejected"
        case .membershipSuspended, .pharmacySuspended: "Suspended"
        case .pharmacyClosed: "Closed"
        }
    }
    
    private var statusIconSystemName: String {
        switch pharmacistRestriction {
        case .membershipPending, .pharmacyPending: "clock"
        case .membershipRejected, .pharmacyRejected: "xmark.circle"
        case .membershipSuspended, .pharmacySuspended: "pause.circle"
        case .pharmacyClosed: "lock"
        }
    }
    
    private var isOwner: Bool { role == .owner }
    
    private var title: String {
        switch pharmacistRestriction {
        case .pharmacyPending:
            isOwner ? "Your pharmacy is pending approval" : "The pharmacy is awaiting approval"
        case .pharmacyRejected:
            isOwner ? "Your pharmacy application was rejected" : "The pharmacy application was rejected"
        case .pharmacySuspended:
            isOwner ? "Your pharmacy is suspended" : "The pharmacy is suspended"
        case .pharmacyClosed:
            isOwner ? "Your pharmacy is closed" : "The pharmacy is closed"
        case .membershipPending:
            "Your request is pending"
        case .membershipRejected:
            "Your request was rejected"
        case .membershipSuspended:
            "You are suspended"
        }
    }
    
    private var reason: String? {
        switch pharmacistRestriction {
        case .pharmacyRejected(let reason), .membershipRejected(let reason): reason
        case .membershipPending: nil
        default: nil
        }
    }
}

extension PharmacistRestriction {
    var color: Color {
        switch self {
        case .membershipPending, .pharmacyPending: .theme.goldenBrown
        case .membershipRejected, .pharmacyRejected: .theme.red
        case .membershipSuspended, .pharmacySuspended: .theme.blue
        case .pharmacyClosed: .theme.brown
        }
    }
    
    var bgColor: Color {
        switch self {
        case .membershipPending, .pharmacyPending: .theme.goldenBrownBackground
        case .membershipRejected, .pharmacyRejected: .theme.redBackground
        case .membershipSuspended, .pharmacySuspended: .theme.blueBackground
        case .pharmacyClosed: .theme.brownBackground
        }
    }
}

#Preview {
    PharmacistRestrictedHomeScreen(
        user: .samples[0],
        role: .owner,
        pharmacistRestriction: .pharmacySuspended,
    )
}

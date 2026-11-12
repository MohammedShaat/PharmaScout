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
        VStack(spacing: DesignSystem.Spacing.large) {
            VStack(spacing: DesignSystem.Spacing.large) {
                icon
                status
            }
            
            VStack(spacing: DesignSystem.Spacing.large) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                if let detail {
                    Text(detail)
                        .foregroundStyle(.theme.textSecondary)
                }
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.xLarge)
        .roundedBackground()
    }
    
    private var anotherPharmacySection: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                Image(systemName: "person.badge.plus")
                    .font(.headline)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(8)
                    .background(.theme.white)
                    .clipShape(.circle)
                
                Text("Want to work with another pharmacy or register your own?")
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                +
                Text(" Open your Profile and look under “Pharmacy”.")
                    .foregroundStyle(.theme.textSecondary)
            }
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(background: .mintTint)
    }
    
    private var icon: some View {
        let systemName = switch pharmacistRestriction {
        case .membershipPending, .pharmacyPending: "hourglass"
        case .membershipRejected, .pharmacyRejected: "xmark.circle"
        case .membershipSuspended, .pharmacySuspended: "pause.circle"
        case .pharmacyClosed: "lock"
        }
        
        return BigIconView(
            systemName: systemName,
            iconColor: pharmacistRestriction.color,
            bgColor: pharmacistRestriction.bgColor
        )
    }
    
    private var status: some View {
        Label {
            switch pharmacistRestriction {
            case .membershipPending, .pharmacyPending: Text("Pending")
            case .membershipRejected, .pharmacyRejected: Text("Rejected")
            case .membershipSuspended, .pharmacySuspended: Text("Suspended")
            case .pharmacyClosed: Text("Closed")
            }
        } icon: {
            switch pharmacistRestriction {
            case .membershipPending, .pharmacyPending: Image(systemName: "clock")
            case .membershipRejected, .pharmacyRejected: Image(systemName: "xmark.circle")
            case .membershipSuspended, .pharmacySuspended: Image(systemName: "pause.circle")
            case .pharmacyClosed: Image(systemName: "lock")
            }
        }
        .fontWeight(.semibold)
        .foregroundStyle(pharmacistRestriction.color)
        .capsuleBackground(background: pharmacistRestriction.bgColor)
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

        private var detail: String? {
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

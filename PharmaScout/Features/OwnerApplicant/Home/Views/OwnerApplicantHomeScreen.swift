//
//  OwnerApplicantHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct OwnerApplicantHomeScreen: View {
    private let user: AppUser
    private let tabVM: OwnerApplicantTabViewModel
    private let ownerApplicationSummary: OwnerApplicationSummary
    
    init(
        user: AppUser,
        ownerApplicantTabViewModel: OwnerApplicantTabViewModel,
        ownerApplicationSummary: OwnerApplicationSummary,
    ) {
        self.user = user
        self.tabVM = ownerApplicantTabViewModel
        self.ownerApplicationSummary = ownerApplicationSummary
    }
    
    var body: some View {
        CustomNavStack {
            CenteredScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    headerSection
                    Spacer()
                    
                    explanationSection
                    
                    if ownerApplicationSummary.status == .rejected {
                        anotherApplicationSection
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
            mainIconColor: ownerApplicationSummary.status.color,
            mainIconBgColor: ownerApplicationSummary.status.surfaceColor,
            statusLabel: statusLabel,
            statusIconSystemName: statusIconSystemName,
            statusIconColor: ownerApplicationSummary.status.color,
            statusIconBgColor: ownerApplicationSummary.status.surfaceColor
        ) {
            if ownerApplicationSummary.status == .approved {
                HStack(spacing: DesignSystem.Spacing.large) {
                    Text("Create pharmacy")
                    Image(systemName: "chevron.forward")
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.theme.onPrimary)
                .capsuleBackground(background: .theme.primary, verticalPadding: DesignSystem.Spacing.large, horizontalPadding: DesignSystem.Spacing.large)
                .clickable {
                    tabVM.navigateToCreatePharmacyTab()
                }
                .padding(.vertical, DesignSystem.Spacing.large)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.xLarge)
        .roundedBackground()
    }
    
    private var anotherApplicationSection: some View {
        DestinationSuggestionView(
            systemName: "key.horizontal",
            title: "Have a new ownership code?",
            destinationString: "You can apply again from your Profile."
        )
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(background: .mintTint)
    }
    
    private var title: String {
        switch ownerApplicationSummary.status {
        case .pending: "Your request is pending"
        case .approved: "You’re approved"
        case .rejected: "Your request was rejected"
        case .issued, .revoked: ""
        }
    }
    
    private var mainIconSystemName: String {
        switch ownerApplicationSummary.status {
        case .pending: "hourglass"
        case .approved: "checkmark.circle"
        case .rejected: "xmark.circle"
        case .issued, .revoked: ""
        }
    }
    
    private var statusLabel: String {
        switch ownerApplicationSummary.status {
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        case .issued, .revoked: ""
        }
    }
    
    private var statusIconSystemName: String {
        switch ownerApplicationSummary.status {
        case .pending: "clock"
        case .approved: "checkmark.circle"
        case .rejected: "xmark.circle"
        case .issued, .revoked: ""
        }
    }
}

#Preview {
    OwnerApplicantHomeScreen(
        user: .samples[0],
        ownerApplicantTabViewModel: .sample,
        ownerApplicationSummary: .samples[2],
    )
}

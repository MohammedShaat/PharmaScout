//
//  OwnerApplicationDetailInfoView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct OwnerApplicationDetailInfoView: View {
    let ownerApplication: OwnerApplication
    
    var body: some View {
        Group {
            codeAndStatus
            
            timeline
            
            if ownerApplication.status != .revoked {
                people
            }
        }
    }
    
    private var codeAndStatus: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            // Status & expiration date
            HStack(spacing: DesignSystem.Spacing.medium) {
                OwnerApplicationStatusView(status: ownerApplication.status)
                    .fontWeight(.bold)
                
                if ownerApplication.status == .issued && ownerApplication.expired {
                    Label("Expired · \(ownerApplication.expiresAt.dayMonthHourMinute)", systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.goldenBrown)
                        .capsuleBackground(background: .theme.goldenBrownBackground)
                }
            }
            
            HStack(spacing: DesignSystem.Spacing.medium) {
                // Code
                Text(ownerApplication.code)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(DesignSystem.Spacing.large)
                    .roundedBackground(background: .disabledBackground, radius: DesignSystem.CornerRadius.small)
                
                // Copy button
                CopyButtonView(text: ownerApplication.code)
            }
            
            Text("This code hasn't been used.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.theme.staleGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(
            showBorder: ownerApplication.status == .pending,
            borderColor: ownerApplication.status.color
        )
    }
    
    private var timeline: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xLarge) {
            Text("Timeline")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
            
            timelineItem(title: "Issued", at: ownerApplication.createdAt, systemName: "key")
            
            switch ownerApplication.status {
            case .issued:
                EmptyView()
            
            case .revoked:
                timelineItem(title: "Revoked", at: nil, systemName: "circle.slash", iconColor: .theme.staleGray)
            
            case .pending:
                timelineItem(
                    title: "Redeemed",
                    at: ownerApplication.redeemedAt,
                    systemName: "person",
                    iconColor: ownerApplication.status.color,
                    iconBgolor: ownerApplication.status.surfaceColor
                )
                timelineItem(
                    title: "Awaiting review",
                    at: nil,
                    systemName: "clock",
                    titleColor: .theme.blueGray,
                    iconColor: .theme.blueGray,
                    iconBgolor: .theme.offWhite
                )
           
            case .approved, .rejected:
                timelineItem(title: "Redeemed", at: ownerApplication.redeemedAt, systemName: "person")
                timelineItem(
                    title: ownerApplication.status.title,
                    at: ownerApplication.reviewedAt,
                    systemName: ownerApplication.status == .approved ? "checkmark.circle" : "xmark.circle",
                    iconColor: ownerApplication.status.color,
                    iconBgolor: ownerApplication.status.surfaceColor
                )
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
    
    private var people: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xLarge) {
            Text("People")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
            
            if let applicantId = ownerApplication.applicantId {
                Label("Applicant", systemImage: "person")
                    .font(.subheadline)
                    .foregroundStyle(.theme.staleGray)
                
                HStack(spacing: DesignSystem.Spacing.large) {
                    Text(applicantId)
                        .padding(DesignSystem.Spacing.large)
                        .roundedBackground(background: .theme.mintTint, radius: DesignSystem
                            .CornerRadius.small)
                    
                    CopyButtonView(text: ownerApplication.code)
                }
                
            } else if ownerApplication.status != .issued {
                Label("No applicant yet", systemImage: "person")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
    
    private func timelineItem(
        title: String,
        at date: Date?,
        systemName: String,
        titleColor: Color = .theme.textPrimary,
        iconColor: Color = .theme.textPrimary,
        iconBgolor: Color = .theme.mintTint
    ) -> some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
            Image(systemName: systemName)
                .foregroundStyle(iconColor)
                .circleBackground(background: iconBgolor)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(titleColor)
                
                if let date {
                    Text(date.formattedDateTime)
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                }
            }
        }
    }
}

#Preview {
    CustomNavStack {
        OwnerApplicationDetailInfoView(ownerApplication: .samples[1])
            .padding()
    }
}

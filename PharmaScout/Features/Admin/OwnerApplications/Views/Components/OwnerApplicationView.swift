//
//  OwnerApplicationView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct OwnerApplicationView: View {
    let ownerApplication: OwnerApplication
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            status
            
            code
            
            if let applicantId = ownerApplication.applicantId {
                applicant(
                    applicantId,
                    hasReviewed: ownerApplication.status != .pending,
                    date: ownerApplication.reviewedAt ?? ownerApplication.redeemedAt
                )
            }
            
            creationDate
            
            if ownerApplication.status == .pending {
                needsReview
            }
        }
    }
    
    private var status: some View {
        OwnerApplicationStatusView(status: ownerApplication.status)
            .fontWeight(.bold)
            .disclosureIndicator()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var code: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text(ownerApplication.code)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.theme.textPrimary)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .disabledBackground, radius: DesignSystem.CornerRadius.small)
            
            CopyButtonView(text: ownerApplication.code)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func applicant(_ applicantId: String, hasReviewed: Bool, date: Date?) -> some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Label("Applicant ", systemImage: "person")
                .font(.subheadline)
                .foregroundStyle(.theme.textPrimary)
            
            Text(applicantId)
                .font(.footnote)
                .foregroundStyle(.theme.staleGray)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text(hasReviewed ? "Reviewed" : "Redeemed")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            if let date {
                Text(date.dayMonthHourMinute)
                    .font(.footnote)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var creationDate: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text("Created")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            Text(ownerApplication.createdAt.dayMonthHourMinute)
                .font(.footnote)
                .foregroundStyle(.theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var needsReview: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text("Needs review")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(OwnerApplicationStatus.pending.color)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: OwnerApplicationStatus.pending.surfaceColor, radius: DesignSystem.CornerRadius.small)
        }
    }
}


#Preview {
    CustomNavStack {
        VStack(spacing: 50) {
            ForEach(Array(OwnerApplication.samples.prefix(3))) { application in
                OwnerApplicationView(ownerApplication: application)
                    .padding(DesignSystem.Spacing.large)
                    .roundedBackground()
            }
        }
        .padding()
    }
}

//
//  PharmacyApplicationView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct PharmacyApplicationView: View {
    let pharmacyApplication: PharmacyApplication
    
    private var reviewed: Bool { pharmacyApplication.status != .pending }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            status
            
            detail
            
            if pharmacyApplication.status == .pending {
                needsReview
            }
        }
    }
    
    private var status: some View {
        PharmacyStatusView(status: pharmacyApplication.status)
            .font(.subheadline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var detail: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.large) {
            IconView(
                size: 44,
                iconColor: pharmacyApplication.status != .closed ? .theme.primary : .theme.textSecondary
            ) {
                Image(.pharmacy)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                Text(pharmacyApplication.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Label {
                        Text(pharmacyApplication.timezone)
                    } icon: {
                        Image(.location)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    .foregroundStyle(.theme.textSecondary)
                    
                    
                    if reviewed, let reviewedAt = pharmacyApplication.reviewedAt {
                        HStack(spacing: DesignSystem.Spacing.small) {
                            Text("Reviewed")
                                .fontWeight(.bold)
                                .foregroundStyle(.theme.textPrimary)
                            
                            Text(reviewedAt.dayMonthHourMinute)
                                .foregroundStyle(.theme.staleGray)
                        }
                    }
                    
                    HStack(spacing: DesignSystem.Spacing.small) {
                        Text("Submitted")
                            .fontWeight(reviewed ? .regular : .bold)
                            .foregroundStyle(reviewed ? .theme.staleGray : .theme.textPrimary)
                        
                        Text(pharmacyApplication.createdAt.dayMonthHourMinute)
                            .foregroundStyle(.theme.staleGray)
                    }
                }
                .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var needsReview: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text("Needs review")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(PharmacyStatus.pending.color)
                .disclosureIndicator(color: PharmacyStatus.pending.color)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: PharmacyStatus.pending.surfaceColor, radius: DesignSystem.CornerRadius.small)
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 50) {
            ForEach(Array(PharmacyApplication.samples.prefix(3))) { application in
                PharmacyApplicationView(pharmacyApplication: application)
                    .padding(DesignSystem.Spacing.large)
                    .roundedBackground()
            }
        }
        .padding()
    }
}

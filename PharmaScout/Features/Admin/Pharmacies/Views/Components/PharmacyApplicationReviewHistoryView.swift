//
//  PharmacyApplicationReviewHistoryView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct PharmacyApplicationReviewHistoryView: View {
    let pharmacyApplication: PharmacyApplication
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            item(title: "Submitted", value: pharmacyApplication.createdAt.formattedDateTime)
            
            if let reviewedAt = pharmacyApplication.reviewedAt {
                DividerView()
                item(title: "Reviewed on", value: reviewedAt.formattedDateTime)
            }
            
            if let reviewedBy = pharmacyApplication.reviewedBy {
                DividerView()
                item(title: "Reviewed by", value: reviewedBy)
            }
            
            if pharmacyApplication.status == .rejected,
               let rejectionReason = pharmacyApplication.rejectionReason {
                DividerView()
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("Reason from the reviewer")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.staleGray)
                    
                    Text("“\(rejectionReason)”")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.theme.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .theme.mintTint)
            }
        }
    }
    
    private func item(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.theme.staleGray)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
        }
        .font(.subheadline)
    }
}

#Preview {
    let pharmacyApplication = PharmacyApplication.samples[0]
    
    CustomNavStack {
        PharmacyApplicationReviewHistoryView(pharmacyApplication: pharmacyApplication)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
            .padding()
    }
}

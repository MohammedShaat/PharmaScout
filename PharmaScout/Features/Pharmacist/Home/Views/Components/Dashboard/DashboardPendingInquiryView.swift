//
//  DashboardInquiryView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import SwiftUI

struct DashboardPendingInquiryView: View {
    let inquiry: Inquiry
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            InquiryStatusView(status: InquiryStatus.pending)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                // Generic name
                Text(inquiry.genericName)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: DesignSystem.Spacing.small) {
                    // Strength
                    Text(inquiry.drugFormulation.strength)
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                        .lineLimit(1)
                    Spacer()
                    // Arrow
                    HStack(spacing: DesignSystem.Spacing.small) {
                        Text("Respone")
                        Image(systemName: "arrow.right")
                    }
                    .font(.subheadline)
                    .foregroundStyle(InquiryStatus.pending.color)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        DashboardPendingInquiryView(inquiry: .samples[0])
            .padding()
    }
}

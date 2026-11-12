//
//  InquiryView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/4/26.
//

import SwiftUI

struct InquiryView: View {
    let inquiry: Inquiry
    
    init(_ inquiry: Inquiry) {
        self.inquiry = inquiry
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            // Status
            InquiryStatusView(status: inquiry.status)
                .font(.subheadline)
                .fontWeight(.bold)
            
            // Generic name and strengths
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall ) {
                Text(inquiry.genericName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(inquiry.drugFormulation.strength)
                    .foregroundStyle(.theme.textSecondary)
            }
            .lineLimit(1)
            
            
            HStack(spacing: DesignSystem.Spacing.medium) {
                Text("Response")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
                
                InquiryResponseView(response: inquiry.response)
                    .font(.subheadline)
                    .padding(.horizontal, DesignSystem.Spacing.small)
                    .padding(.vertical, DesignSystem.Spacing.xSmall)
                    .roundedBackground(
                        background: .clear,
                        radius: DesignSystem.CornerRadius.small,
                        showBorder: true,
                        borderColor: inquiry.response?.color ?? .theme.textSecondary
                    )
            }
            
            DividerView()
            HStack(spacing: DesignSystem.Spacing.xLarge) {
                Label("Sent \(inquiry.createdAt.dayMonth)", systemImage: "clock")
                
                if let respondedAt = inquiry.respondedAt{
                    Label("Responded \(respondedAt.dayMonth)", systemImage: "paperplane")
                }
            }
            .font(.footnote)
            .foregroundStyle(.theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(showBorder: inquiry.status == .pending, borderColor: InquiryStatus.pending.color)
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
	        
        VStack(spacing: 30) {
            ForEach(0...2, id: \.self) { _ in
                InquiryView(.samples.randomElement()!)
            }
        }
        .padding()
    }
}

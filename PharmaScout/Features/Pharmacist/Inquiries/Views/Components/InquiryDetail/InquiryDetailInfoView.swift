//
//  InquiryDetailInfoView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct InquiryDetailInfoView: View {
    let inquiry: Inquiry
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            // Status
            InquiryStatusView(status: inquiry.status)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal, DesignSystem.Spacing.large)
            
            // Generic name and formulation
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium ) {
                Text(inquiry.genericName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    formulationRow(title: "Strength", value: inquiry.drugFormulation.strength)
                    
                    DividerView(color: .theme.disabledContent)
                    formulationRow(title: "Form", value: inquiry.drugFormulation.form)

                    DividerView(color: .theme.disabledContent)
                    formulationRow(title: "Route", value: inquiry.drugFormulation.route)
                }
                .padding(DesignSystem.Spacing.large)
                .background(.theme.mintTint)
            }
            
            // Response
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
            .padding(.horizontal, DesignSystem.Spacing.large)
            
            if let substituteGenericName = inquiry.substituteGenericName,
               let substituteDrugFormulation = inquiry.substituteDrugFormulation {
                SubstituteView(
                    genericName: substituteGenericName,
                    strength: substituteDrugFormulation.strength,
                    form: substituteDrugFormulation.form
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .theme.blueBackground, radius: DesignSystem.CornerRadius.small)
                .padding(.horizontal, DesignSystem.Spacing.medium)
            }
            
            DividerView()
            // Dates
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                Label("Sent \(inquiry.createdAt.formattedDateTime)", systemImage: "clock")
                
                if let respondedAt = inquiry.respondedAt{
                    Label("Responded \(respondedAt.formattedDateTime)", systemImage: "paperplane")
                }
            }
            .font(.callout)
            .foregroundStyle(.theme.textSecondary)
            .padding(.horizontal, DesignSystem.Spacing.large)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, DesignSystem.Spacing.large)
        .roundedBackground(showBorder: inquiry.status == .pending, borderColor: InquiryStatus.pending.color)
    }
    
    private func formulationRow(title: String, value: String) -> some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.theme.textSecondary)
                .containerRelativeFrame(.horizontal, alignment: .leading, { width, _ in  width * 0.15 })
            
            Text(value)
                .font(.body)
                .foregroundStyle(.theme.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InquiryDetailInfoView(inquiry: .samples.randomElement()!)
        .padding()
}

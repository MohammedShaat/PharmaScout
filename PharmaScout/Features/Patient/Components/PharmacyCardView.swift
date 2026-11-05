//
//  CardListItemView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct PharmacyCardView: View {
    let name: String
    let distance: Double
    let isOpen: Bool
    var rate: Double?
    var responseRate: Int?
    
    var body: some View {
        HStack {
            healthIcon

            content
        }
        .foregroundStyle(.theme.textPrimary)
        .padding(DesignSystem.Spacing.medium)
        .background(.theme.surface)
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .stroke(lineWidth: 2)
                .fill(.theme.borderFilled)
        }
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
        .frame(maxWidth: .infinity)
    }

    private var healthIcon: some View {
        Image(.pharmacy)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 35)
            .foregroundStyle(.theme.secondaryStrong)
            .padding(DesignSystem.Spacing.small)
            .background(.theme.disabledBackground)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
            HStack {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                workStatus
            }
            
            Text(distance.formattedDistance)
                .foregroundStyle(.theme.textSecondary)
                .font(.callout)
        }
    }

    private var workStatus: some View {
        Text(isOpen ? "Open" : "Closed")
            .foregroundStyle(isOpen ? .theme.green : .theme.textSecondary)
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.vertical, DesignSystem.Spacing.xSmall)
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .background(isOpen ? .theme.greenBackground : .theme.disabledBackground)
            .clipShape(.capsule)
    }
}

#Preview {
    VStack(spacing: 50) {
        PharmacyCardView(
            name: "Al-Shifa Pharmacy",
            distance: 10_000,
            isOpen: true,
            rate: 4.7,
            responseRate: 92,
        )
        
        PharmacyCardView(
            name: "Care Pharmacy",
            distance: 5_000,
            isOpen: false,
            rate: 3,
            responseRate: 67,
        )
    }
    .padding()
}

//
//  CardListItemView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct CardListItemView: View {
    let name: String
    let rate: Double
    let distance: String
    let responseRate: Int
    let isOpen: Bool
    private var statusColor: Color {
        isOpen ? .theme.success : .theme.error
    }
    
    var body: some View {
        HStack {
            healthIcon

            content
        }
        .foregroundStyle(.theme.textPrimary)
        .padding(Spacing.medium)
        .background(.theme.surface)
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                .stroke(lineWidth: 2)
                .fill(.theme.borderFilled)
        }
        .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
        .frame(maxWidth: .infinity)
    }

    private var healthIcon: some View {
        Image(.pharmacy)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 35)
            .foregroundStyle(.theme.secondaryStrong)
            .padding(Spacing.small)
            .background(.theme.disabledBackground)
            .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            // MARK: Title and work hour
            HStack {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                workStatus
            }

            // MARK: Details (rating, distance, ...)
            HStack(spacing: Spacing.xSmall) {
                HStack(spacing: Spacing.xSmall) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    
                    Text(rate, format: .number)
                        .foregroundStyle(.theme.textLabel)
                        .fontWeight(.medium)
                }
                
                Text(" · ")
                
                Text(distance)
                
                Text(" · ")
                
                Text("\(responseRate)% replies")
            }
            .foregroundStyle(.theme.textSecondary)
            .font(.callout)
        }
    }

    private var workStatus: some View {
        Text(isOpen ? "Open" : "Close")
            .foregroundStyle(statusColor)
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
            .background(statusColor.opacity(0.15))
            .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
    }
}

#Preview {
    VStack(spacing: 50) {
        CardListItemView(
            name: "Al-Shifa Pharmacy",
            rate: 4.7,
            distance: "10 km",
            responseRate: 92,
            isOpen: true
        )
        
        CardListItemView(
            name: "Care Pharmacy",
            rate: 3,
            distance: "5 km",
            responseRate: 67,
            isOpen: false
        )
    }
        .padding()
}

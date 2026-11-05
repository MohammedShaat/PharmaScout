//
//  RadioCardView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct RadioCardView<Icon: View>: View {
    let isSelected: Bool
    let title: String
    let description: String
    @ViewBuilder let icon: Icon
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            icon
                .foregroundStyle(.theme.primary)
                .padding(DesignSystem.Spacing.medium)
                .roundedBackground(
                    background: isSelected ? .theme.secondary.opacity(0.5) : .theme.disabledBackground,
                    radius: DesignSystem.CornerRadius.small
                )
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(description)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.theme.textSecondary)
            }
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isSelected ? .theme.primary : .theme.disabledContent)
            
            
        }
        .padding(DesignSystem.Spacing.large)
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .strokeBorder(.theme.primary, style: .init(lineWidth: 1.5))
            }
        }
        .roundedBackground()
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20){
            RadioCardView(isSelected: true, title: "Option 1", description: "This is option 1") { Image(.pharmacy) }
            
            RadioCardView(isSelected: false, title: "Option 2", description: "This is option 2") { Image(.personPlusFill) }
        }
    }
}

//
//  ListItemVIew.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct ListItemVIew: View {
    let name: String
    let strength: String
    let quantity: Int
    
    var body: some View {
        HStack {
            pillIcon

            content

            Spacer()

            returnButton
        }
        .foregroundStyle(.theme.textPrimary)
    }

    private var pillIcon: some View {
        Image(systemName: "pill")
            .fontWeight(.medium)
            .padding(DesignSystem.Spacing.medium)
            .background(.theme.disabledBackground)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
            Text(name)
                .font(.headline)
                .lineLimit(1)

            HStack(spacing: 0) {
                Text(strength)
                Text(" · ")
                Text("\(quantity) units")
            }
            .foregroundStyle(.theme.textSecondary)
            .font(.callout)
        }
    }

    private var returnButton: some View {
        Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
            .fontWeight(.medium)
            .rotationEffect(.degrees(-45))
            .foregroundStyle(.theme.onPrimary)
            .padding(DesignSystem.Spacing.medium)
            .background(.theme.primary)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
}

#Preview {
    ListItemVIew(name: "Ibuprofen", strength: "200 mg", quantity: 10)
        .padding()
        .background(.gray.opacity(0.4))
}

//
//  ListItemVIew.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct HomeSearchRowView: View {
    let search: Search
    
    private var genericNames: [String] { search.drugs.map(\.genericName) }
    private var strengths: [String] { search.drugs.map(\.strength) }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            PillIconView()
                .font(.system(size: 22))
                .fontWeight(.medium)
                .foregroundStyle(.theme.primary)
            
            content
            Spacer()
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(genericNames, format: .list(type: .and))
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(strengths.joined(separator: " - "))
                    .foregroundStyle(.theme.textSecondary)
                    .font(.callout)
            }
            
            HStack(spacing: DesignSystem.Spacing.medium) {
                SearchStatusView(status: search.status)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(search.createdAt, format: .dateTime.day().month(.abbreviated))
                    .foregroundStyle(.theme.textSecondary	)
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        VStack(spacing: 50) {
            Group {
                HomeSearchRowView(search: .samples[0])
                
                HomeSearchRowView(search: .samples[1])
                
                HomeSearchRowView(search: .samples[2])
            }
            .padding()
            .roundedBackground()
        }
            .padding()
    }
}

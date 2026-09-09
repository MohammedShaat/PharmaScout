//
//  SearchCardView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SearchCardView: View {
    var onSearchFieldCliced: () -> Void = {}
    @State private var size: CGSize = .zero
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            prompt
            
            searchField
        }
        .padding(DesignSystem.Spacing.large)
        .background(alignment: .topTrailing) { cornerCircle }
        .background(.theme.primary)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
        .readFrame { size = $0.size }
    }
    
    private var prompt: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack(spacing: DesignSystem.Spacing.xSmall) {
                Image(systemName: "pill")
                    .font(.callout)
                
                Text("MEDICINE FINDER")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.theme.secondary)
            
            Text("Find your medicine")
                .foregroundStyle(.theme.onPrimary)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Search nearby pharmacies for the medicine you need.")
                .foregroundStyle(.theme.background)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var searchField: some View {
        HStack(spacing: DesignSystem.Spacing.large) {
            
            Image(systemName: "magnifyingglass")
                .padding(DesignSystem.Spacing.medium)
                .background(.surface.opacity(0.0001))
                .clickable(action: onSearchFieldCliced)
            
            Text("Search for a medicine")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(.surface.opacity(0.0001))
                .clickable(action: onSearchFieldCliced)
            
        }
        .foregroundStyle(.theme.textSecondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.theme.surface)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
    
    private var cornerCircle: some View {
        Circle()
            .fill(.theme.secondary.opacity(0.15))
            .frame(height: size.height / 1.2)
            .alignmentGuide(.top) { dimen in dimen[VerticalAlignment.center] / 1.2 }
            .alignmentGuide(.trailing) { dimen in dimen[HorizontalAlignment.center] / 0.78 }
            .overlay {
                Circle()
                    .stroke()
                    .fill(.theme.secondary.opacity(0.5))
                    .frame(width: size.height / 2.5)
            }
    }
}

#Preview {
    SearchCardView()
        .padding()
}

//
//  PlaceSuggestionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/19/26.
//

import SwiftUI

struct PlaceSuggestionView: View {
    let place: PlaceSuggestion
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            IconView(size: 40, iconColor: .theme.primary) {
                Image(.location)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(place.title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(place.subtitle)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.theme.blueGray)
            }
        }
    }
}

#Preview {
    PlaceSuggestionView(place: .samples[0])
}

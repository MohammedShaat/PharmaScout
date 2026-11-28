//
//  DestinationSuggestionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/19/26.
//

import SwiftUI

struct DestinationSuggestionView: View {
    let systemName: String
    let title: String
    let destinationString: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                Image(systemName: systemName)
                    .font(.headline)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(8)
                    .background(.theme.white)
                    .clipShape(.circle)
                
                Text("\(title) ")
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                +
                Text(destinationString)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
    }
}

#Preview {
    DestinationSuggestionView(
        systemName: "person.badge.plus",
        title: "Want to work with another pharmacy or register your own?",
        destinationString: "Open your Profile and look under “Pharmacy”."
    )
}

//
//  ErrorView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
        Image(systemName: "exclamationmark.circle")
        
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(title)
                .fontWeight(.bold)
            Text(description)
        }
    }
    .foregroundStyle(.theme.red)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(DesignSystem.Spacing.large)
    .roundedBackground(background: .theme.redBackground)
    }
}

#Preview {
    ErrorView(title: "Couldn't send your response.", description: "The server isn’t reachable. Your changes are still here.")
}

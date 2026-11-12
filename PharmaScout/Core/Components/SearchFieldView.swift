//
//  SearchFieldView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var text: String
    let placehodler: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.theme.textSecondary)
            
            TextField(text: $text) {
                Text(placehodler)
                    .foregroundStyle(.theme.textSecondary)
            }
            .foregroundStyle(.theme.textPrimary)
            .padding(DesignSystem.Spacing.medium)
            
            Image(systemName: "xmark")
                .foregroundStyle(.theme.textSecondary)
                .padding(DesignSystem.Spacing.small)
                .background(.theme.disabledBackground.opacity(0.001))
                .clickable { text = "" }
        }
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.xSmall)
        .roundedBackground(radius: DesignSystem.CornerRadius.small)
    }
}

#Preview {
    @State @Previewable var text = ""
    
    CustomNavStack {
        SearchFieldView(text: $text, placehodler: "type here")
            .padding()
    }
}

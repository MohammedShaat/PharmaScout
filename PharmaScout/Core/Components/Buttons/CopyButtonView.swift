//
//  CopyButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct CopyButtonView: View {
    let text: String
    
    var body: some View {
        Image(systemName: "doc.on.doc")
            .foregroundStyle(.theme.textPrimary)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(background: .clear, radius: DesignSystem.CornerRadius.small, showBorder: true)
            .clickable {
                copyToClipboard(text)
            }
    }
}

#Preview {
    CopyButtonView(text: "Text to copy")
}

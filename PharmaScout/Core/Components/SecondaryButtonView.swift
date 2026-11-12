//
//  SecondaryButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct SecondaryButtonView: View {
    let title: String
    let systemName: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Label(title, systemImage: systemName)
            .foregroundStyle(.theme.green)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(background: .clear, radius: DesignSystem.CornerRadius.small, showBorder: true, borderColor: .theme.green)
            .clickable(action: action)
    }
}

#Preview {
    SecondaryButtonView(title: "Add contact", systemName: "plus")
}

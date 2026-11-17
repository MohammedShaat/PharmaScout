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
    var color: Color = .theme.green
    var isDisabled: Bool = false
    var maxWidth: CGFloat? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Label(title, systemImage: systemName)
            .frame(maxWidth: maxWidth)
            .foregroundStyle(color)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(background: .clear, radius: DesignSystem.CornerRadius.small, showBorder: true, borderColor: color)
            .clickable(isDisabled: isDisabled, action: action)
    }
}

#Preview {
    SecondaryButtonView(title: "Add contact", systemName: "plus")
}

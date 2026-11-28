//
//  DisclosureIndicator.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct DisclosureIndicator: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            content
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundStyle(color)
        }
    }
}

extension View {
    func disclosureIndicator(color: Color = .theme.disabledContent) -> some View {
        modifier(DisclosureIndicator(color: color))
    }
}

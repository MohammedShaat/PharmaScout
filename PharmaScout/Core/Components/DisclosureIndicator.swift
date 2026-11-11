//
//  DisclosureIndicator.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct DisclosureIndicator: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            content
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundStyle(.theme.disabledContent)
        }
    }
}

extension View {
    func disclosureIndicator() -> some View {
        modifier(DisclosureIndicator())
    }
}

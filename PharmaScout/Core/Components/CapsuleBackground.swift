//
//  RoundedBackground.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct CapsuleBackground: ViewModifier {
    var bgColor: Color = .theme.surface
    var verticalPadding: Double = DesignSystem.Spacing.xSmall
    var horizontalPadding: Double = DesignSystem.Spacing.medium
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(bgColor)
            .clipShape(.capsule)
    }
}


extension View {
    func capsuleBackground(
        background: Color = .theme.surface,
        verticalPadding: Double = DesignSystem.Spacing.xSmall,
        horizontalPadding: Double = DesignSystem.Spacing.medium,
    ) -> some View {
        modifier(
            CapsuleBackground(
                bgColor: background,
                verticalPadding: verticalPadding,
                horizontalPadding: horizontalPadding,
            )
        )
    }
}

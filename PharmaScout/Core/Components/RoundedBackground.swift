//
//  RoundedBackground.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct RoundedBackground: ViewModifier {
    var bgColor: Color = .theme.surface
    var radius: Double = DesignSystem.CornerRadius.large
    var showBorder: Bool = false
    var borderColor: Color = .theme.disabledBackground
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if showBorder {
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(borderColor, style: .init(lineWidth: 1.5))
                }
            }
            .background(bgColor)
            .clipShape(.rect(cornerRadius: radius))
    }
}


extension View {
    func roundedBackground(
        background: Color = .theme.surface,
        radius: Double = DesignSystem.CornerRadius.large,
        showBorder: Bool = false,
        borderColor: Color = .theme.disabledBackground
    ) -> some View {
        modifier(
            RoundedBackground(
                bgColor: background,
                radius: radius,
                showBorder: showBorder,
                borderColor: borderColor
            )
        )
    }
}

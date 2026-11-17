//
//  RoundedBackground.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct CircleBackground: ViewModifier {
    var bgColor: Color
    var padding: Double
    var showBorder: Bool
    var borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .overlay {
                if showBorder {
                    Circle()
                        .stroke(borderColor, style: .init(lineWidth: 1.5))
                }
            }
            .background(bgColor)
            .clipShape(.circle)
    }
}


extension View {
    func circleBackground(
        background: Color = .theme.surface,
        padding: Double = DesignSystem.Spacing.medium,
        showBorder: Bool = false,
        borderColor: Color = .theme.disabledBackground
    ) -> some View {
        modifier(
            CircleBackground(
                bgColor: background,
                padding: padding,
                showBorder: showBorder,
                borderColor: borderColor
            )
        )
    }
}

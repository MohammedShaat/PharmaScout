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
    
    func body(content: Content) -> some View {
        content
            .background(bgColor)
            .clipShape(.rect(cornerRadius: radius))
    }
}


extension View {
    func roundedBackground(background: Color = .theme.surface, radius: Double = DesignSystem.CornerRadius.large) -> some View {
        modifier(RoundedBackground(bgColor: background, radius: radius))
    }
}

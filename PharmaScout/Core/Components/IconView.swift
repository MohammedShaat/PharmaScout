//
//  IconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct IconView: View {
    let systemName: String
    var size: Double = 24
    var iconColor: Color = .theme.primary
    var bgColor: Color = .theme.mintTint
    var padding: Double = DesignSystem.Spacing.small
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.5))
            .foregroundStyle(iconColor)
            .padding(padding)
            .frame(width: size, height: size)
            .roundedBackground(background: bgColor, radius: DesignSystem.CornerRadius.small)
    }
}

#Preview {
    IconView(systemName: "person")
}

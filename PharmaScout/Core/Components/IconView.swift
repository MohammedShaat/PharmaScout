//
//  IconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct IconView<Icon: View>: View {
    let systemName: String?
    var size: Double
    var iconColor: Color
    var bgColor: Color
    var padding: Double
    var icon: Icon?
    
    var body: some View {
        Group {
            if let icon {
                icon
            } else {
                Image(systemName: systemName ?? "")
            }
        }
        .font(.system(size: size * 0.5))
        .foregroundStyle(iconColor)
        .padding(padding)
        .frame(width: size, height: size)
        .roundedBackground(background: bgColor, radius: DesignSystem.CornerRadius.small)
    }
}

#Preview {
    IconView(systemName: "person")
    
    IconView {
        Image(.pharmacy)
            .renderingMode(.template)
    }
}

extension IconView {
    init(
        systemName: String,
        size: Double = 24,
        iconColor: Color = .theme.primary,
        bgColor: Color = .theme.mintTint,
        padding: Double = DesignSystem.Spacing.small,
    ) where Icon == EmptyView {
        self.init(
            systemName: systemName,
            size: size,
            iconColor: iconColor,
            bgColor: bgColor,
            padding: padding,
            icon: nil
        )
    }
    
    init(
        size: Double = 24,
        iconColor: Color = .theme.primary,
        bgColor: Color = .theme.mintTint,
        padding: Double = DesignSystem.Spacing.small,
        @ViewBuilder icon: () -> Icon
    ) {
        self.init(
            systemName: nil,
            size: size,
            iconColor: iconColor,
            bgColor: bgColor,
            padding: padding,
            icon: icon()
        )
    }
}

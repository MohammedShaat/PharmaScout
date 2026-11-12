//
//  BigIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/16/26.
//

import SwiftUI

struct BigIconView: View {
    let systemName: String
    var size: Double = 100
    var iconColor: Color = .theme.primary
    var bgColor: Color = .theme.mintTint
    var padding: Double = DesignSystem.Spacing.small
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.4))
            .foregroundStyle(iconColor)
            .padding(padding)
            .frame(width: size, height: size)
            .background(bgColor)
            .clipShape(.circle)
    }
}

#Preview {
    BigIconView(systemName: "person")
}

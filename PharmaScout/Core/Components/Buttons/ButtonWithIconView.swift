//
//  ButtonWithIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/16/26.
//

import SwiftUI

struct ButtonWithIconView: View {
    let title: String
    let systemName: String
    var color: Color = .theme.onPrimary
    var bgColor: Color = .theme.primary
    var font: Font = .body
    var isDisabled: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Label {
            Text(title)
                .font(font)
                .fontWeight(.bold)
        } icon: {
            Image(systemName: systemName)
        }
        .foregroundStyle(color)
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.vertical, DesignSystem.Spacing.large)
        .roundedBackground(background: bgColor, radius: DesignSystem.CornerRadius.small)
        .clickable(isDisabled: isDisabled, action: action)
    }
}

#Preview {
    ZStack{
        Color.theme.background.ignoresSafeArea()
        
        ButtonWithIconView(title: "Copy", systemName: "doc.on.doc")
    }
}

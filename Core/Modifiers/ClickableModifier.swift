//
//  ButtonStyle.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct ClickableModifier: ViewModifier {
    var isDisabled: Bool = false
    var action: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        Button {
            action?()
        } label: {
            content
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

extension View {
    func clickable(isDisabled: Bool = false, action: (() -> Void)? = nil) -> some View {
        modifier(ClickableModifier(isDisabled: isDisabled, action: action))
    }
}

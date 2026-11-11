//
//  PrimaryButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct PrimaryButtonView: View {
    let title: String
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var bgColor: Color = .theme.primary
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if isDisabled || isLoading {
                PrimaryButtonLabelView(title: title, isDisabled: isDisabled, isLoading: isLoading, bgColor: bgColor)
            } else {
                PrimaryButtonLabelView(title: title, bgColor: bgColor)
                    .clickable(action: action)
            }
        }
        .frame(maxWidth: 400)
    }
}

#Preview {
    VStack(spacing: 30) {
        PrimaryButtonView(title: "Click me")
        
        PrimaryButtonView(title: "Click me", isDisabled: true)
        
        PrimaryButtonView(title: "Click me", isLoading: true)
    }
        .padding()
}

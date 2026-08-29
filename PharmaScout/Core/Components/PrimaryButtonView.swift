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
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if isDisabled {
                PrimaryButtonLabelView(title: title, isDisabled: true)
            } else {
                PrimaryButtonLabelView(title: title)
                    .clickable(action: action)
            }
        }
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 50) {
        PrimaryButtonView(title: "Click me")
        
        PrimaryButtonView(title: "Click me", isDisabled: true)
    }
        .padding()
}

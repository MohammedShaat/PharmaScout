//
//  ActionPromptView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import SwiftUI

struct NavigationPromptView<H: Hashable>: View {
    let value: H
    var text: String = ""
    let actionTitle: String
    
    var body: some View {
        HStack(spacing: Spacing.medium) {
            Text(text)
                .foregroundStyle(.theme.textSecondary)
            
            CustomNavValueLink(value: value) {
                Text(actionTitle)
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    CustomNavStack {
        NavigationPromptView(value: "", text: "Remembered it?", actionTitle: "Back to Sign Up")
    }
}

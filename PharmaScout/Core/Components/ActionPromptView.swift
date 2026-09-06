//
//  ActionPromptView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import SwiftUI

struct ActionPromptView: View {
    var text: String = ""
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.medium) {
            Text(text)
                .foregroundStyle(.theme.textSecondary)
            
            Text(actionTitle)
                .foregroundStyle(.theme.primary)
                .font(.headline)
                .clickable {
                    action()
                }
        }
    }
}

#Preview {
    CustomNavStack {
        ActionPromptView(text: "Remembered it?", actionTitle: "Back to Sign Up") {
            
        }
    }
}

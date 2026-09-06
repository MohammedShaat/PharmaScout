//
//  ActionPromptView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import SwiftUI

struct NavigationPromptView<Content: View>: View {
    var text: String = ""
    let actionTitle: String
    let destination: Content
    
    init(text: String = "", actionTitle: String, @ViewBuilder destination: () -> Content) {
        self.text = text
        self.actionTitle = actionTitle
        self.destination = destination()
    }
    
    var body: some View {
        HStack(spacing: Spacing.medium) {
            Text(text)
                .foregroundStyle(.theme.textSecondary)
            
            CustomNavLink {
                destination
            } label: {
                Text(actionTitle)
                    .foregroundStyle(.theme.primary)
                    .font(.headline)
            }
            
        }
    }
}

#Preview {
    CustomNavStack {
        NavigationPromptView(text: "Remembered it?", actionTitle: "Back to Sign Up") {
            
        }
    }
}

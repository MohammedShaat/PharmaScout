//
//  OrDividerView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import SwiftUI

struct OrDividerView: View {
    var body: some View {
        HStack(spacing: Spacing.large) {
            Rectangle()
                .fill(.theme.borderFocused)
                .frame(height: 0.5)
            
            Text("OR")
                .foregroundStyle(.theme.textSecondary)
            
            Rectangle()
                .fill(.theme.borderFocused)
                .frame(height: 0.5)
        }
    }
}

#Preview {
    OrDividerView()
}

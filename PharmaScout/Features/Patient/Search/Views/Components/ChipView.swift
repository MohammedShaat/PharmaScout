//
//  ChipVIew.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct ChipView: View {
    let name: String
    var isCancelable: Bool = true
    var onCancelTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Text(name)
                .fontWeight(.bold)
            
            if isCancelable {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .padding(DesignSystem.Spacing.small)
                    .background(.theme.secondary.opacity(0.001))
                    .clickable(action: onCancelTapped)
            }
        }
        .foregroundStyle(.theme.onPrimary)
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
        .roundedBackground(background: .theme.primary)
    }
}

#Preview {
    HStack {
        ChipView(name: "One", onCancelTapped: nil)
        ChipView(name: "Two", onCancelTapped: nil)
    }
}

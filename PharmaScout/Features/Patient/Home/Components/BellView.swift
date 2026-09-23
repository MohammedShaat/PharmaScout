//
//  BellView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import SwiftUI

struct BellView: View {
    let hasUnreadNotifications: Bool
    @State private var size: CGSize = .zero
    
    var body: some View {
        Image(systemName: "bell")
            .foregroundStyle(.theme.textPrimary)
            .font(.title2)
            .readFrame { size = $0.size }
            .overlay(alignment: .topTrailing) {
                if hasUnreadNotifications {
                    dot
                }
            }
            .padding(DesignSystem.Spacing.medium)
            .background(.theme.surface)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
            .shadow(radius: 2)
    }
    
    private var dot: some View {
        Circle()
            .fill(.theme.secondary)
            .frame(width: size.width / 3)
            .padding(size.width / 10)
            .background(
                Circle()
                    .fill(.theme.surface)
                    .frame(width: size.width / 2)
            )
    }
}

#Preview {
    VStack(spacing: 50) {
        BellView(hasUnreadNotifications: true)
        
        BellView(hasUnreadNotifications: false)
    }
    .padding()
    .background(.gray)
}

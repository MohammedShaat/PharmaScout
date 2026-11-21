//
//  RadioView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct RadioView: View {
    let title: String
    var subtitle: String? = nil
    let isSelected: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            VStack(spacing: DesignSystem.Spacing.small) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.theme.textSecondary)
                }
            }

            Spacer()
            
            Group {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Image(systemName: "circle")
                }
            }
            .font(.title)
            .foregroundStyle(.theme.primary)
            
        }
        .frame(maxWidth: .infinity)
        .background(.theme.background.opacity(0.001))
        .clickable(action: action)
    }
}

#Preview {
    VStack(spacing: 50) {
        RadioView(title: "Option 1", subtitle: "This is a subtitle", isSelected: true)
        
        RadioView(title: "Option 2", subtitle: "This is a subtitle", isSelected: false)
    }
    .padding()
}

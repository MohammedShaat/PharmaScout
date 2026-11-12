//
//  SectionHeaderWithActionView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct SectionHeaderWithActionView<Icon: View>: View {
    let title: String
    let actionName: String
    var isActionDisabled: Bool = false
    @ViewBuilder let icon: Icon
    var onActionTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textSecondary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.small) {
                icon

                Text(actionName)
                    .fontWeight(.semibold)
            }
            .font(.callout)
            .clickable(isDisabled: isActionDisabled, action: onActionTapped)
            
        }
        .foregroundStyle(.theme.textPrimary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 100) {
        SectionHeaderWithActionView(title: "Recent rows", actionName: "Seee all") {
            Image(systemName: "chevron.right")
        }
        
        SectionHeaderWithActionView(title: "Contacts", actionName: "Edit") {
            Image(systemName: "pencil")
        }
    }
        .padding()
}

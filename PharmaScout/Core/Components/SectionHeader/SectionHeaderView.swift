//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct SectionHeaderView<Icon: View>: View {
    let title: String
    let actionName: String
    @ViewBuilder let icon: Icon
    var onActionTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xSmall) {
                Text(actionName)
                    .fontWeight(.medium)
                
                icon
            }
            .font(.subheadline)
            .clickable(action: onActionTapped)
            
        }
        .foregroundStyle(.theme.textPrimary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 100) {
        SectionHeaderView(title: "Recent rows", actionName: "Seee all") {
            Image(systemName: "chevron.right")
        }
        
        SectionHeaderView(title: "Contacts", actionName: "Edit") {
            Image(systemName: "pencil")
        }
    }
        .padding()
}

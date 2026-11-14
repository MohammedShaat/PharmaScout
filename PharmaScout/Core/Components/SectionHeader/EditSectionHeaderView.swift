//
//  EditSectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct EditSectionHeaderView<Content: View>: View {
    let title: String
    var showAction: Bool = true
    var onActionTapped: (() -> Void)?
    let content: Content
    
    init(
        title: String,
        showAction: Bool = true,
        onActionTapped: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.showAction = showAction
        self.onActionTapped = onActionTapped
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Spacer()
                
                if showAction {
                    Label {
                        Text("Edit")
                    } icon: {
                        Image(systemName: "pencil")
                            .font(.headline)
                    }
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.green)
                    .padding(DesignSystem.Spacing.medium)
                    .roundedBackground(background: .theme.greenBackground)
                    .clickable(action: onActionTapped)
                }
            }
            .frame(maxWidth: .infinity)
            
            content
        }
    }
}

#Preview {
    EditSectionHeaderView(title: "Address")
        .padding()
}

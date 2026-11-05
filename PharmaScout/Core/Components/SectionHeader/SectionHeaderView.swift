//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct SectionHeaderView<Content: View>: View {
    let title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text(title.uppercased())
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textSecondary)
                
                Spacer()
            }
            .foregroundStyle(.theme.textPrimary)
            .frame(maxWidth: .infinity)
            
            content
        }
    }
}

#Preview {
    VStack(spacing: 100) {
        SectionHeaderView(title: "Recent rows")
        
        SectionHeaderView(title: "Contacts")
    }
        .padding()
}

//
//  ProfileSectionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct ProfileSectionView: View {
    let sectionTitle: String
    @CustomViewBuilder let rows: [AnyView]
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: sectionTitle)
            
            VStack(spacing: DesignSystem.Spacing.large) {
                ForEach(rows.indices, id: \.self) { index in
                    rows[index]
                    
                    if index != rows.count - 1 {
                        DividerView()
                    }
                }
            }
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
        }
    }
}

@resultBuilder
struct CustomViewBuilder {
    static func buildExpression<Content: View>(_ expression: Content) -> [AnyView] {
        [AnyView(expression)]
    }
    
    static func buildBlock(_ components: [AnyView]...) -> [AnyView] {
        components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [AnyView]?) -> [AnyView] {
        component ?? []
    }
}

#Preview {
    ProfileSectionView(sectionTitle: "Session") {
        
    }
}

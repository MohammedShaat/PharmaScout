//
//  ProfileSectionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct ProfileSectionView<Content: View>: View {
    let sectionTitle: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: sectionTitle)
            
            content
        }
    }
}

#Preview {
    ProfileSectionView(sectionTitle: "Session") {
        
    }
}

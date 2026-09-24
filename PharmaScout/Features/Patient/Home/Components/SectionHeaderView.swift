//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var onSeeAllClicked: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xSmall) {
                Text("See all")
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.right")
            }
            .font(.subheadline)
            .clickable(action: onSeeAllClicked)
            
        }
        .foregroundStyle(.theme.textPrimary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SectionHeaderView(title: "Recent searchs")
        .padding()
        .customNavBarVisibility(false)
}

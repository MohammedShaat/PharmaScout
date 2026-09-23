//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SectionHeaderView<H: Hashable>: View {
    let value: H
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            CustomNavValueLink(value: value) {
                HStack(spacing: DesignSystem.Spacing.xSmall) {
                    Text("See all")
                        .fontWeight(.medium)
                    
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
            }

        }
        .foregroundStyle(.theme.textPrimary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CustomNavStack {
        SectionHeaderView(value: "", title: "Recent searchs")
        .padding()
        .customNavBarVisibility(false)
    }
}

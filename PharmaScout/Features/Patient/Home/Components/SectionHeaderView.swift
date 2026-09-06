//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SectionHeaderView<Destination: View>: View {
    let title: String
    let destination: Destination
    
    init(title: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            CustomNavLink {
                destination 
            } label: {
                HStack(spacing: Spacing.xSmall) {
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
        SectionHeaderView(title: "Recent searchs") {
            
        }
        .padding()
        .customNavBarVisibility(false)
    }
}

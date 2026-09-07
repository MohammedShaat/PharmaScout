//
//  ListView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        VStack {
            SectionHeaderView(value: "", title: "Recent searchs")
            
            list
        }
    }
    
    private var list: some View {
        VStack(spacing: 0) {
            ForEach(0...2, id: \.self) { i in
                VStack(spacing: 0) {
                    ListItemVIew(name: "Ibuprofen", strength: "200 mg", quantity: 10)
                        .padding(Spacing.medium)
                    
                    if i < 2 {
                        Rectangle()
                            .fill(.theme.borderFilled)
                            .frame(height: 1)
                    }
                }
            }
        }
        .background(.theme.surface)
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                .stroke(lineWidth: 2)
                .fill(.theme.borderFilled)
        }
        .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
    }
    
    
}

#Preview {
    CustomNavStack {
        ListView()
            .padding()
            .customNavBarVisibility(false)
    }
}

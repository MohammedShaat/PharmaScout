//
//  ListView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SearchListView: View {
    var body: some View {
        VStack {
            SectionHeaderView(title: "Recent searchs")
            
            list
        }
    }
    
    private var list: some View {
        VStack(spacing: 0) {
            ForEach(0...2, id: \.self) { i in
                VStack(spacing: 0) {
                    SearchItemView(name: "Ibuprofen", strength: "200 mg",)
                        .padding(DesignSystem.Spacing.medium)
                    
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
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .stroke(lineWidth: 2)
                .fill(.theme.borderFilled)
        }
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
    
    
}

#Preview {
    CustomNavStack {
        SearchListView()
            .padding()
            .customNavBarVisibility(false)
    }
}

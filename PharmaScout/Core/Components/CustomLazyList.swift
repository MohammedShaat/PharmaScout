//
//  CustomLazyList.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct CustomLazyList<Item: Identifiable, V: View>: View {
    let items: [Item]
    let isLoadingMore: Bool
    @ViewBuilder let itemView: (Item) -> V
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            ForEach(items) { item in
                itemView(item)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                if !item.isLast(items) {
                    DividerView()
                }
            }
        }
        .padding(.vertical, items.isEmpty ? 0 : DesignSystem.Spacing.large)
        .roundedBackground(showBorder: true)
        
        if isLoadingMore {
            RingProgressView()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CustomNavStack {
        CustomLazyList(items: Array(GenericDrug.samples.prefix(5)), isLoadingMore: false) { drug in
            Text(drug.genericName)
        }
        .padding()
    }
}

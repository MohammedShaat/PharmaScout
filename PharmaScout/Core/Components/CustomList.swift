//
//  CustomLazyList.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct CustomList<Item: Identifiable, V: View>: View {
    let items: [Item]
    let isLoadingMore: Bool
    @ViewBuilder let itemView: (Item) -> V
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            ForEachView(items: items, itemView: itemView)
        }
        .padding(.vertical, items.isEmpty ? 0 : DesignSystem.Spacing.large)
        .roundedBackground(showBorder: true)
        
        LoadingMoreView(isLoadingMore: isLoadingMore)
    }
}

struct CustomLazyList<Item: Identifiable, V: View>: View {
    let items: [Item]
    let isLoadingMore: Bool
    @ViewBuilder let itemView: (Item) -> V
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            ForEachView(items: items, itemView: itemView)
        }
        .padding(.vertical, items.isEmpty ? 0 : DesignSystem.Spacing.large)
        .roundedBackground(showBorder: true)
        
        LoadingMoreView(isLoadingMore: isLoadingMore)
    }
}

private struct ForEachView<Item: Identifiable, V: View>: View {
    let items: [Item]
    @ViewBuilder let itemView: (Item) -> V
    
    var body: some View {
        ForEach(items) { item in
            itemView(item)
                .padding(.horizontal, DesignSystem.Spacing.large)
            
            if !item.isLast(items) {
                DividerView()
            }
        }
    }
}

private struct LoadingMoreView: View {
    let isLoadingMore: Bool
    
    var body: some View {
        if isLoadingMore {
            RingProgressView()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CustomNavStack {
        CustomList(items: Array(GenericDrug.samples.prefix(5)), isLoadingMore: false) { drug in
            Text(drug.genericName)
        }
        .padding()
    }
}

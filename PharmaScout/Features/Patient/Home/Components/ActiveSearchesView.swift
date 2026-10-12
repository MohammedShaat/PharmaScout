//
//  ActiveSearchesView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/28/26.
//

import SwiftUI

struct ActiveSearchesView: View {
    let activeSearches: [Search]
    let loadingState: LoadingState
    var onItemTapped: ((Search) -> Void)? = nil
    
    var body: some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: activeSearches.isEmpty,
            emptyMessage: "No active searches") {
                VStack {
                    Text("Searching nearby pharamcies")
                        .foregroundStyle(.theme.success)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        ForEach(activeSearches) { search in
                            activeSearchItem(search)
                                .clickable {
                                    onItemTapped?(search)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
    }
    
    private func activeSearchItem(_ search: Search) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
            Text(search.drugs.map(\.genericName), format: .list(type: .and))
                .font(.headline)
                .lineLimit(1)
            
            let percentage = Double(search.fulfilledDrugsCount) / Double(search.drugsCount)
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(.theme.disabledBackground)
                .frame(height: 4)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                        .fill(.theme.success)
                        .containerRelativeFrame(.horizontal, alignment: .leading) { width, _ in
                            width * percentage
                        }
                }
        }
        .padding(DesignSystem.Spacing.small)
        .background(.theme.primary.opacity(0.2))
    }
}

#Preview {
    ActiveSearchesView(
        activeSearches: Search.samples.filter { $0.status == .pending },
        loadingState: LoadingState()
    )
}

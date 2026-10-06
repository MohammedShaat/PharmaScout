//
//  ListView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SearchListView: View {
    let searches: [Search]
    let loadingState: LoadingState
    var onSeeAllTapped: (() -> Void)?
    var onSearchTapped: ((Search) -> Void)?
    
    var body: some View {
        VStack {
            MoreSectionHeaderView(title: "Recent searchs", onActionTapped: onSeeAllTapped)
            
            list
        }
    }
    
    private var list: some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: searches.isEmpty,
            emptyMessage: "There is no searches, start a one") {
                VStack(spacing: 0) {
                    ForEach(searches) { search in
                        VStack(spacing: 0) {
                            SearchItemView(search: search)
                                .padding(DesignSystem.Spacing.medium)
                                .background(.theme.background.opacity(0.001))
                                .clickable {
                                    onSearchTapped?(search)
                                }
                            
                            if search.id != searches.last?.id {
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
    
}

#Preview {
    CustomNavStack {
        SearchListView(
            searches: Array(Search.samples.prefix(2)),
            loadingState: LoadingState()
        )
            .padding()
            .customNavBarVisibility(false)
    }
}

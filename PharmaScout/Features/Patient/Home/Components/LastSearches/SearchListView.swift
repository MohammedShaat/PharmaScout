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
            showMessage: searches.isEmpty,
            emptyTitle: "No completed searches yet",
            emptyMessage: "Your completed searches will appear here.") {
                CustomList(
                    items: searches,
                    isLoadingMore: false
                ) { search in
                    HomeSearchRowView(search: search)
                        .disclosureIndicator()
                        .clickable {
                            onSearchTapped?(search)
                        }
                }
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
    }
}

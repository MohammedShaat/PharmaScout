//
//  RecentSearchesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct RecentSearchesScreen: View {
    @State private var vm: RecentSearchesViewModel
    @State private var searchesTask: Task<Void, Never>?
    
    init(searchRequestService: SearchRequestService) {
        let viewModel = RecentSearchesViewModel(
            searchRequestService: searchRequestService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                
                LoadingContentView(
                    LoadingState: vm.loadingState,
                    isEmpty: vm.searches.isEmpty,
                    emptyMessage: "There is no searches") {
                        LazyVStack(spacing: DesignSystem.Spacing.medium) {
                            ForEach(vm.searches) { search in
                                searchItemView(search)
                                    .onAppear {
                                        if search.id == vm.searches.last?.id {
                                            searchesTask?.cancel()
                                            searchesTask = Task {
                                                await vm.loadMore()
                                            }
                                        }
                                    }
                                
                                if search.id == vm.searches.last?.id && vm.loadingState.status == .loadingMore {
                                    RingProgressView()
                                }
                            }
                        }
                    }
                
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .onDisappear {
            searchesTask?.cancel()
        }
        .refreshable(action: vm.refresh)
        .taskOnFirstAppear {
            await vm.loadSearches()
        }
    }
    
    private func searchItemView(_ search: Search) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                ForEach(search.items) { item in
                    Text("\(item.genericName) - \(item.strength)")
                }
            }
            HStack {
                Spacer()
                Text(search.status.rawValue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.3))
    }
}

#Preview {
    RecentSearchesScreen(
        searchRequestService: MockSearchRequestService.sample
    )
}

//
//  RecentSearchesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct RecentSearchesScreen: View {
    private let searchRequestService: SearchRequestService
    private let locationService: LocationService
    private let patientTabViewModel: PatientTabViewModel
    
    var path: Binding<NavigationPath>
    @State private var vm: RecentSearchesViewModel
    @State private var searchesTask: Task<Void, Never>?
    
    init(
        path: Binding<NavigationPath>,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        patientTabViewModel: PatientTabViewModel
    ) {
        self.path = path
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.patientTabViewModel = patientTabViewModel
        let viewModel = RecentSearchesViewModel(
            searchRequestService: searchRequestService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: path) {
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
            .customNavBarVisibility(false)
            .customNavigationDestination(for: Search.self) { search in
                SearchDetailScreen(
                    searchRequestService: searchRequestService,
                    locationService: locationService,
                    patientTabViewModel: patientTabViewModel,
                    search: search
                )
            }
            .onDisappear {
                searchesTask?.cancel()
            }
            .refreshable(action: vm.refresh)
            .onAppear(perform: vm.loadSearchesIfNeeded)
        }
    }
    
    private func searchItemView(_ search: Search) -> some View {
        CustomNavValueLink(value: search) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    ForEach(search.drugs) { searchDrug in
                        Text("\(searchDrug.genericName) - \(searchDrug.strength)")
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
}

#Preview {
    @State @Previewable var path = NavigationPath()
    
    RecentSearchesScreen(
        path: $path,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        patientTabViewModel: PatientTabViewModel.sample
    )
}

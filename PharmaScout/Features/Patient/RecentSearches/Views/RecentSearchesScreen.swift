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
    private let appConfigService: AppConfigService
    
    var path: Binding<NavigationPath>
    @State private var vm: RecentSearchesViewModel
    @State private var searchesTask: Task<Void, Never>?
    
    init(
        path: Binding<NavigationPath>,
        userId: String,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        patientTabViewModel: PatientTabViewModel,
        appConfigService: AppConfigService
    ) {
        self.path = path
        self.searchRequestService = searchRequestService
        self.locationService = locationService
        self.appConfigService = appConfigService
        
        self.patientTabViewModel = patientTabViewModel
        let viewModel = RecentSearchesViewModel(
            userId: userId,
            searchRequestService: searchRequestService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: path) {
            VStack(spacing: 0) {
                filterSection
                    .padding(.vertical, DesignSystem.Spacing.medium)

                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        searchListSection
                    }
                    
                }
                .refreshable(action: vm.refresh)
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Recent searches")
            .customNavigationDestination(for: SearchDetailRoute.self) { route in
                SearchDetailScreen(
                    searchRequestService: searchRequestService,
                    locationService: locationService,
                    appConfigService: appConfigService,
                    patientTabViewModel: patientTabViewModel,
                    searchId: route.searchId,
                    search: route.search
                )
                .id(route.searchId)
            }
            .onDisappear {
                searchesTask?.cancel()
            }
            .onAppear(perform: vm.loadSearchesIfNeeded)
            .onChange(of: vm.filter) {
                searchesTask?.cancel()
                searchesTask = Task {
                    await vm.onFilterChanged()
                }
            }
            .task(vm.listenToChanges)
        }
    }
    
    private var filterSection: some View {
        FilterView(
            selection: $vm.filter,
            title: vm.filter.title,
            pickerTitle: "Status",
            options: SearchFilter.allCases,
            content: { status in
                Text(status.title)
            }
        )
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var searchListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            showMessage: vm.searches.isEmpty,
            emptyTitle: "No recent searches",
            emptyMessage: "Your recent medicine searches will appear here once you start searching."
        ) {
            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(vm.searches) { search in
                    SearchView(search: search)
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
}

#Preview {
    @State @Previewable var path = NavigationPath()
    
    RecentSearchesScreen(
        path: $path,
        userId: AppUser.samples[0].id,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        patientTabViewModel: PatientTabViewModel.sample,
        appConfigService: MockAppConfigService.sample
    )
}

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
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    filterSection
                    
                    searchListSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
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
            .refreshable(action: vm.refresh)
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
        Menu(vm.filter.title, systemImage: "line.3.horizontal.decrease") {
            Picker("Status", selection: $vm.filter) {
                ForEach(SearchFilter.allCases) { status in
                    Text(status.title)
                        .tag(status)
                }
            }
        }
    }
    
    private var searchListSection: some View {
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
    
    private func searchItemView(_ search: Search) -> some View {
        CustomNavValueLink(value: SearchDetailRoute(searchId: search.id, search: search)) {
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
        userId: AppUser.samples[0].id,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        patientTabViewModel: PatientTabViewModel.sample,
        appConfigService: MockAppConfigService.sample
    )
}

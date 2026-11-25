//
//  SearchDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import SwiftUI

struct SearchDetailRoute: Hashable {
    let searchId: String
    var search: Search? = nil
}

struct SearchDetailScreen: View {
    private let patientTabViewModel: PatientTabViewModel
    @State private var vm: SearchDetailViewModel
    @State private var continueSearchTask: Task<Void, Never>?
    
    private var isAwaitingContinuation: Bool { vm.search?.status == .awaitingContinuation }
    
    init(
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        appConfigService: AppConfigService,
        patientTabViewModel: PatientTabViewModel,
        searchId: String,
        search: Search?
    ) {
        self.patientTabViewModel = patientTabViewModel
        let viewModel = SearchDetailViewModel(
            searchRequestService: searchRequestService,
            locationService: locationService,
            appConfigService: appConfigService,
            searchId: searchId,
            search: search
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    searchSummarySection
                    
                    drugDetailsSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .refreshable(action: vm.refresh)
            
            if isAwaitingContinuation {
                continuationSection
            }
        }
        .ignoresSafeArea(edges: isAwaitingContinuation ? .bottom : [])
        .toolbarVisibility(isAwaitingContinuation ? .hidden : .automatic, for: .tabBar)
        .customNavTitle("Search Details")
        .onAppear {
            vm.loadSearchAndDetailIfNeeded()
        }
        .onDisappear {
            continueSearchTask?.cancel()
        }
        .task(vm.listenToChanges)
    }
    
    private var searchSummarySection: some View {
        LoadingContentView(
            loadingState: vm.searchLoadingState,
            showMessage: vm.search == nil,
            emptyTitle: "Search not found",
            emptyMessage: "This search may have been removed or is no longer available.",
            errorTitle: "Couldn't load the search"
        ) {
            if let search = vm.search {
                SearchSummaryView(search: search)
            }
        }
    }
    
    private var drugDetailsSection: some View {
        LoadingContentView(
            loadingState: vm.detailLoadingState,
            showMessage: vm.searchDrugDetails.isEmpty,
            emptyTitle: "No medicine details",
            emptyMessage: "No medicine details are available for this search.",
            errorTitle: "Couldn't load medicine details"
        ) {
            VStack(spacing: DesignSystem.Spacing.large) {
                Text("Drugs detail")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.searchDrugDetails) { searchDrugDetail in
                        SearchDrugDetailView(
                            searchDrugDetail: searchDrugDetail,
                            onPharmacyTapped: {
                                patientTabViewModel.navigateToPharmacyDetailScreen(for: $0)
                            }
                        )
                    }
                }
            }
            .padding(.vertical, DesignSystem.Spacing.large)
        }
    }
    
    private var continuationSection: some View {
        LoadingContentView(
            loadingState: vm.distanceConfigsLoadingState,
            showMessage: vm.maxDistanceMeters == nil && vm.minDistanceMeters == nil,
            emptyTitle: "Search distance unavailable",
            emptyMessage: "We couldn't find the search distance settings. Please try again later.",
            errorTitle: "Couldn't load search distance settings",
            showIcon: false
        ) {
            if let minDistanceMeters = vm.minDistanceMeters,
               let maxDistanceMeters = vm.maxDistanceMeters {
                ContinuationView(
                    distanceMeters: $vm.distanceMeters,
                    minDistanceMeters: minDistanceMeters,
                    maxDistanceMeters: maxDistanceMeters,
                    search: vm.search,
                    continueSearchLoadingState: vm.continueSearchLoadingState,
                    onContinueSearchTapped: {
                        continueSearchTask?.cancel()
                        continueSearchTask = Task {
                            await vm.continueSearch()
                        }
                    }
                )
            }
        }
        .frame(minHeight: 150)
        .frame(maxWidth: .infinity)
        .padding([.horizontal, .top], DesignSystem.Spacing.large)
        .padding(.bottom, DesignSystem.Spacing.xxLarge)
        .background(.theme.surface)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: DesignSystem.CornerRadius.large,
                topTrailingRadius: DesignSystem.CornerRadius.large
            )
        )
        .shadow(radius: 5, y: -3)
    }
}

#Preview {
    let search = Search.samples[3]
    
    TabView {
        Tab {
            CustomNavStack {
                SearchDetailScreen(
                    searchRequestService: MockSearchRequestService.sample,
                    locationService: MockLocationService.sample,
                    appConfigService: MockAppConfigService.sample,
                    patientTabViewModel: PatientTabViewModel.sample,
                    searchId: search.id,
                    search: search
                )
            }
        }
    }
}

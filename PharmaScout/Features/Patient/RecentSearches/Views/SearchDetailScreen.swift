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
            
            if vm.search?.status == .awaitingContinuation {
                continuationSection
            }
        }
        .ignoresSafeArea(edges: [.bottom])
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
            LoadingState: vm.searchLoadingState,
            showMessage: vm.search == nil,
            emptyMessage: "No search found") {
                if let search = vm.search {
                    SearchSummaryView(search: search)
                }
            }
    }
    
    private var drugDetailsSection: some View {
        LoadingContentView(
            LoadingState: vm.detailLoadingState,
            showMessage: vm.searchDrugDetails.isEmpty,
            emptyMessage: "No results found") {
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
            LoadingState: vm.distanceConfigsLoadingState,
            showMessage: vm.maxDistanceMeters == nil && vm.minDistanceMeters == nil,
            emptyMessage: "",
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

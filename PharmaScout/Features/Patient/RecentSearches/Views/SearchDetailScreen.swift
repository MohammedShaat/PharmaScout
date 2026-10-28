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
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                
                searchSection
                
                drugDetailsSection
                
                if vm.search?.status == .awaitingContinuation {
                    continuationSection
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .refreshable(action: vm.refresh)
        .onAppear {
            vm.loadSearchAndDetailIfNeeded()
        }
        .onDisappear {
            continueSearchTask?.cancel()
        }
        .task(vm.listenToChanges)
    }
    
    private var searchSection: some View {
        LoadingContentView(
            LoadingState: vm.searchLoadingState,
            isEmpty: vm.search == nil,
            emptyMessage: "") {
                if let search = vm.search {
                    VStack(alignment: .leading) {
                        Text("Accept substitute: \(search.acceptSubstitute.description)")
                        Text("Fulfilment mode: \(search.fulfilmentMode.rawValue)")
                        Text("Status: \(search.status.rawValue)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
    }
    
    private var drugDetailsSection: some View {
        LoadingContentView(
            LoadingState: vm.detailLoadingState,
            isEmpty: vm.searchDrugDetails.isEmpty,
            emptyMessage: "There is no details") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.searchDrugDetails) { searchDrugDetail in
                        searchDrugDetailItem(searchDrugDetail)
                    }
                }
            }
    }
    
    private var continuationSection: some View {
        LoadingContentView(
            LoadingState: vm.distanceConfigsLoadingState,
            isEmpty: vm.maxDistanceMeters == nil && vm.minDistanceMeters != nil,
            emptyMessage: "") {
                if let minDistanceMeters = vm.minDistanceMeters,
                   let maxDistanceMeters = vm.maxDistanceMeters {
                    
                    VStack {
                        if vm.showExpandRadius {
                            DistanceSliderView(
                                distance: $vm.distanceMeters,
                                minDistanceMeters: minDistanceMeters,
                                maxDistanceMeters: maxDistanceMeters,
                                label: "Expand search radius to"
                            )
                        } else {
                            Text("Expand search distance?")
                                .foregroundStyle(.theme.textPrimary)
                                .clickable(action: vm.onShowExpandTapped)
                        }
                        
                        if let error = vm.continueSearchLoadingState.error {
                            Text(error.errorDescription)
                        }
                        
                        PrimaryButtonView(
                            title: "Continue Search",
                            isLoading: vm.continueSearchLoadingState.status != .idle
                        ) {
                            continueSearchTask?.cancel()
                            continueSearchTask = Task {
                                await vm.continueSearch()
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.xxxLarge)
                }
            }
    }
    
    private func searchDrugDetailItem(_ searchDrugDetail: SearchDrugDetail) -> some View {
        VStack(alignment: .leading) {
            Text(searchDrugDetail.genericName)
            Text(searchDrugDetail.drugFormulation.title)
            
            HStack {
                Spacer()
                
                // Still pending
                if searchDrugDetail.status == .pending {
                    Text("Waiting")
                    
                } else {
                    // There is reponse from a pharmacy
                    if let response = searchDrugDetail.response {
                        VStack {
                            Text(response.pharmacyResponse.rawValue)
                            
                            Text(response.pharmacy.name)
                                .clickable {
                                    patientTabViewModel.navigateToPharmacyDetailScreen(for: response.pharmacy)
                                }
                        }
                        
                    // No response
                    } else {
                        Text("No response")
                    }
                }
                
            }
            
            if searchDrugDetail.response?.pharmacyResponse == .substitute,
               let response = searchDrugDetail.response,
               let substituteGenericName = response.substituteGenericName,
               let substituteFormulation = response.substituteDrugFormulation {
                Text(substituteGenericName)
                Text(substituteFormulation.title)
            }
        }
        .background(.gray.opacity(0.3))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let search = Search.samples[0]
    
    SearchDetailScreen(
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        appConfigService: MockAppConfigService.sample,
        patientTabViewModel: PatientTabViewModel.sample,
        searchId: search.id,
        search: search
    )
}

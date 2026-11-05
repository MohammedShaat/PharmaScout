//
//  SearchScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import SwiftUI

struct SearchScreen: View {
    private let drugService: DrugService
    private let patientTabViewModel: PatientTabViewModel
    
    @State private var vm: SearchViewModel
    @State private var path = NavigationPath()
    @State private var searchTask: Task<Void, Never>?
    
    @State private var showingStartedSearch: Bool = false
    @State private var submittedSearch: SubmittedSearch?
    
    @State private var showingDrugSelection: Bool = false
    @State private var selectedDrugToEdit: SelectedDrug?
    
    init(
        userId: String,
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        patientTabViewModel: PatientTabViewModel
    ) {
        self.drugService = drugService
        self.patientTabViewModel = patientTabViewModel
        
        let viewModel = SearchViewModel(
            userId: userId,
            searchRequestService: searchRequestService,
            locationService: locationService,
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: $path) {
            CenteredScrollView {
                VStack(spacing: 0) {
                    LoadingContentView(
                        LoadingState: vm.numberOfActiveSearchsLoadingState,
                        showMessage: vm.hasReachedSearchLimit,
                        emptyTitle: "Search limit reached",
                        emptyMessage: "You've reached the maximum number of active search requests. Please wait until one of your current searches is completed before starting a new one.",
                        emptyIcon: {
                            Image(systemName: "hourglass.badge.lock")
                                .font(.system(size: 34))
                                .foregroundStyle(.theme.yellow)
                        }
                    ) {
                            if vm.selectedDrugs.isEmpty {
                                EmptySearchView {
                                    showingDrugSelection = true
                                }
                            } else {
                                ConfiguredSearchView(
                                    selectedDrugs: vm.selectedDrugs,
                                    canAdd: vm.canAddDrug,
                                    onAddTapped: { showingDrugSelection = true },
                                    onCancelTapped:  { id in vm.cancelDrug(id: id) },
                                    onSelectedDrugTapped: { selectedDrugToEdit = $0 },
                                    acceptSubstitutes: $vm.acceptSubstitutes,
                                    fulfilmentMode: $vm.fulfilmentMode,
                                    distanceMeters: $vm.distanceMeters,
                                    minDistance: vm.minDistanceMeters,
                                    maxDistance: vm.maxDistanceMeters,
                                    isCreatingSearchRequest: vm.requestLoadingState.status != .idle,
                                    canStartSearch: vm.canStartSearch) {
                                        searchTask?.cancel()
                                        searchTask = Task {
                                            submittedSearch = await vm.startSearch()
                                            showingStartedSearch = submittedSearch != nil
                                        }
                                    }
                            }
                        }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(.root)
            .customNavTitle("New search")
            .errorAlert(title: "Search Failed", loadingState: $vm.requestLoadingState)
            .alert("No pharmacies", isPresented: $vm.showNoPharmaciesMessage) {
            } message: {
                VStack {
                    Text("No pharmacies within \(vm.distanceMeters.meterToKilometer)km")
                    Text("Expand the distance to search further")
                }
            }
            .customNavBarVisibility(.root)
            .customNavigationDestination(isPresented: $showingStartedSearch) {
                if let submittedSearch {
                    StartedSearchView(
                        distance: submittedSearch.distanceMeters,
                        selectedDrugs: submittedSearch.drugs,
                        onViewSearchTapped: {
                            patientTabViewModel.navigateToSearchDetailScreenBy(submittedSearch.id)
                        }
                    )
                    .onDisappear { showingStartedSearch = false }
                }
            }
            .sheet(isPresented: $showingDrugSelection) {
                DrugSelectionScreen(
                    drugService: drugService,
                    selectedFormulationIds: vm.selectedDrugs.map { $0.formulation.id }
                ) { selectedDrug in
                    vm.addDrug(selectedDrug: selectedDrug)
                }
            }
            .sheet(item: $selectedDrugToEdit) { selectedDrug in
                DrugSelectionScreen(
                    drugService: drugService,
                    editingSelectedDrug: selectedDrug,
                    selectedFormulationIds: vm.selectedDrugs.map { $0.formulation.id }
                )
            }
            .onDisappear {
                searchTask?.cancel()
            }
            .refreshable(action: vm.refresh)
            .taskOnFirstAppear {
                vm.requestLocationPermission()
                await vm.getNumberOfActiveSearchs()
            }
            .task(vm.listenToChanges)
        }
    }
    
}

#Preview {
    SearchScreen(
        userId: AppUser.samples[0].id,
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        patientTabViewModel: .sample
    )
}

//
//  SearchScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import SwiftUI

struct SearchScreen: View {
    private let drugService: DrugService
    
    @State private var vm: SearchViewModel
    @State private var path = NavigationPath()
    @State private var searchTask: Task<Void, Never>?
    
    init(
        userId: String,
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
    ) {
        self.drugService = drugService
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
                        isEmpty: vm.hasReachedSearchLimit,
                        emptyMessage: "You've reached the request limit") {
                            if vm.selectedDrugs.isEmpty {
                                EmptySearchView {
                                    path.append(SearchRoute.addDrug)
                                }
                            } else {
                                ConfiguredSearchView(
                                    selectedDrugs: vm.selectedDrugs,
                                    canAdd: vm.canAddDrug,
                                    onAddTapped: { path.append(SearchRoute.addDrug) },
                                    onCancelTapped:  { id in vm.cancelDrug(id: id) },
                                    acceptSubstitutes: $vm.acceptSubstitutes,
                                    fulfilmentMode: $vm.fulfilmentMode,
                                    distanceMeters: $vm.distanceMeters,
                                    minDistance: vm.minDistanceMeters,
                                    maxDistance: vm.maxDistanceMeters,
                                    isCreatingSearchRequest: vm.requestLoadingState.status != .idle,
                                    canStartSearch: vm.canStartSearch) {
                                        searchTask?.cancel()
                                        searchTask = Task {
                                            await vm.startSearch()
                                        }
                                    }
                            }
                        }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(.root)
            .customNavTitle("Search")
            .errorAlert(title: "Search Failed", loadingState: $vm.requestLoadingState)
            .sheet(isPresented: $vm.showSuccessMessage) {
                MidSheetView(title: "Your request has been submitted successfully") {
                    vm.showSuccessMessage.toggle()
                }
            }
            .alert("No pharmacies", isPresented: $vm.showNoPharmaciesMessage) {
            } message: {
                VStack {
                    Text("No pharmacies within \(vm.distanceMeters.meterToKilometer)km")
                    Text("Expand the distance to search further")
                }
            }
            .customNavBarVisibility(.root)
            .customNavigationDestination(for: SearchRoute.self) { route in
                switch route {
                case .addDrug:
                    DrugSelectionScreen(
                        drugService: drugService,
                        selectedFormulationIds: vm.selectedDrugs.map { $0.formulation.id }
                    ) { selectedDrug in
                        vm.addDrug(selectedDrug: selectedDrug)
                    }
                
                case .editDrug(let selectedDrug):
                    DrugSelectionScreen(
                        drugService: drugService,
                        editingSelectedDrug: selectedDrug,
                        selectedFormulationIds: vm.selectedDrugs.map { $0.formulation.id }
                    )
                }
            }
            .onDisappear {
                searchTask?.cancel()
            }
            .refreshable(action: vm.refresh)
            .task {
                await vm.getNumberOfActiveSearchs()
            }
            .task(vm.listenToChanges)
        }
    }
    
}

enum SearchRoute: Hashable {
    case addDrug
    case editDrug(SelectedDrug)
}

#Preview {
    SearchScreen(
        userId: AppUser.samples[0].id,
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
    )
}

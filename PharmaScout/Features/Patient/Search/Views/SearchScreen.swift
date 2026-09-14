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
    
    init(
        drugService: DrugService,
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        pharmacySerivce: PharmacyService,
    ) {
        self.drugService = drugService
        let viewModel = SearchViewModel(
            searchRequestService: searchRequestService,
            locationService: locationService,
            pharmacySerivce: pharmacySerivce
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    // MARK: - First search nav
                    if vm.selectedDrugs.isEmpty {
                        CustomNavValueLink(value: SearchRoute.drugSelection) {
                            Text("Choose a medicine to start")
                                .padding(DesignSystem.Spacing.medium)
                                .frame(maxWidth: .infinity)
                                .background(.theme.disabledBackground)
                        }
                    }
                    
                    // MARK: - Selected drugs list
                    VStack(spacing: DesignSystem.Spacing.large) {
                        ForEach(vm.selectedDrugs) { selectedDrug in
                            CustomNavValueLink(value: selectedDrug) {
                                selectedDrugItem(selectedDrug: selectedDrug)
                            }
                        }
                    }
                    
                    if vm.selectedDrugs.isNotEmpty {
                        // MARK: - Add more drugs
                        if vm.canAddDrug {
                            CustomNavValueLink(value: SearchRoute.drugSelection) {
                                Text("Add another medicine?")
                                    .foregroundStyle(.theme.primary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        
                        // MARK: - fulfilment + substitue
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                            Toggle(isOn: $vm.acceptSubstitutes) {
                                Text("Accept substitutes")
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                                Text("How should we find them?")
                                
                                Picker(selection: $vm.fulfilmentMode) {
                                    ForEach(FulfilmentMode.allCases) { mode in
                                        Text(mode.rawValue)
                                    }
                                } label: {
                                    Text("")
                                }
                                .pickerStyle(.segmented)
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK: - Start search
                        if vm.canStartSearch {
                            PrimaryButtonView(title: "Start search", isDisabled: vm.isLoading, isLoading: vm.isLoading) {
                                Task {
                                    await vm.startSearch()
                                }
                            }
                        }
                    }
                    
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .errorAlert(title: "Search Failed", error: $vm.requestError)
            .sheet(isPresented: $vm.showSuccessMessage, content: {
                VStack {
                    Text("Your request has been submitted successfully")
                        .foregroundStyle(.theme.success)
                        .font(.title2)
                    
                    PrimaryButtonView(title: "Ok") {
                        vm.showSuccessMessage.toggle()
                    }
                }
                .presentationDetents([.medium])
                .padding(DesignSystem.Spacing.xLarge)
            })
            .customNavBarVisibility(false)
            .customNavigationDestination(for: SelectedDrug.self) { selectedDrug in
                DrugSelectionScreen(drugService: drugService, editingSelectedDrug: selectedDrug)
            }
            .customNavigationDestination(for: SearchRoute.self) { route in
                switch route {
                case .drugSelection:
                    DrugSelectionScreen(drugService: drugService) { selectedDrug in
                        vm.addDrug(selectedDrug: selectedDrug)
                    }
                }
            }
        }
    }
    
    private func selectedDrugItem(selectedDrug: SelectedDrug) -> some View {
        HStack {
            VStack(spacing: DesignSystem.Spacing.medium ) {
                Text(selectedDrug.genericDrug.genericName)
                Text(selectedDrug.formulation.title)
                Text("Quantity: \(selectedDrug.quanity)")
            }
            Spacer()
            Image(systemName: "xmark")
                .padding(DesignSystem.Spacing.small)
                .background(.theme.background.opacity(0.001))
                .clickable {
                    vm.cancelDrug(id: selectedDrug.id)
                }
        }
    }
}

enum SearchRoute {
    case drugSelection
}

#Preview {
    SearchScreen(
        drugService: MockDrugService.sample,
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        pharmacySerivce: MockPharmacyService.sample
    )
}

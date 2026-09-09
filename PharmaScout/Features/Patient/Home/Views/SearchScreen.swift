//
//  SearchScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SearchScreen: View {
    @State private var vm: SearchViewModel
    @FocusState private var isSearchFocus: Bool
    
    init(drugService: DrugService) {
        let viewModel = SearchViewModel(drugSerice: drugService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Selected
                HStack {
                    if let selectedGenericDrug = vm.selectedGenericDrug {
                        capsuleSelectedItem(name: selectedGenericDrug.genericName) {
                            vm.onGenericDrugCanceled()
                        }
                    }
                    
                    if let selectedDrugFormulation = vm.selectedDrugFormulation {
                        capsuleSelectedItem(name: selectedDrugFormulation.title) {
                            vm.onDrugFormulationCanceled()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                // MARK: - TextField
                if !vm.isDrugFormulationSelected {
                    TextField("type here", text: $vm.searchText)
                        .focused($isSearchFocus)
                        .padding()
                        .background(.theme.disabledBackground)
                    
                    if !vm.isGenericDrugSelected {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            Text("Drug name?")
                            
                            Text("Type at least 3 letters to search. For combinations, separate them with any character.")
                                .foregroundStyle(.theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            Text("Formulation?")
                            
                            Text("Enter form, strength, or route. Separate terms with any character.")
                                .foregroundStyle(.theme.textSecondary)
                        }
                    }
                    
                    if vm.isLoading && !vm.paginating && !vm.refreshing {
                        RingProgressView()
                            .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: - Generic drug list
                    if !vm.isGenericDrugSelected {
                        LazyVStack(alignment: .leading) {
                            ForEach(vm.genericDrugs) { genericDrug in
                                genericDrugItem(genericDrug: genericDrug)
                                    .clickable {
                                        Task {
                                            await vm.onGenericDrugClicked(genericDrug: genericDrug)
                                        }
                                    }
                                    .task(id: genericDrug.id) {
                                        if genericDrug.id == vm.genericDrugs.last?.id {
                                            print("Load more...")
                                            await vm.loadMore()
                                        }
                                    }
                                
                                if genericDrug.id == vm.genericDrugs.last?.id && vm.isLoading {
                                    RingProgressView()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                    
                    // MARK: - Formulations list
                    if vm.isGenericDrugSelected {
                        LazyVStack(alignment: .leading) {
                            ForEach(vm.drugFormulations) { drugFormulation in
                                drugFormulationsItem(drugFormulation: drugFormulation)
                                    .clickable {
                                        Task {
                                            await vm.onDrugFormulationClicked(drugFormulaion: drugFormulation)
                                        }
                                    }
                                    .task {
                                        if drugFormulation.id == vm.drugFormulations.last?.id {
                                            print("Load more...")
                                            await vm.loadMore()
                                        }
                                    }
                                
                                if drugFormulation.id == vm.drugFormulations.last?.id && vm.isLoading {
                                    RingProgressView()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
            .errorAlert(title: "Search failed", error: $vm.searchError)
            .onAppear {
                isSearchFocus = true
            }
            .task(id: vm.searchText) {
                await vm.search()
            }
        }
        .refreshable {
            await vm.refresh()
        }
    }
    
    private func genericDrugItem(genericDrug: GenericDrug) -> some View {
        Text(genericDrug.genericName)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding(DesignSystem.Spacing.small)
            .background(.theme.primary.opacity(0.2))
    }
    
    private func drugFormulationsItem(drugFormulation: DrugFormulation) -> some View {
        Text("\(drugFormulation.strength) - \(drugFormulation.route) - \(drugFormulation.form)")
            .font(.headline)
            .padding(DesignSystem.Spacing.small)
            .background(.theme.surface)
    }
    
    private func capsuleSelectedItem(name: String, onCancelClicked: @escaping () -> Void = {}) -> some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Text(name)
            
            Image(systemName: "xmark")
                .font(.subheadline)
                .padding(DesignSystem.Spacing.small)
                .background(.theme.secondary.opacity(0.001))
                .clickable(action: onCancelClicked)
        }
        .foregroundStyle(.theme.textTertiary)
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
        .background(.theme.secondary)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
    }
}

#Preview {
    CustomNavStack {
        SearchScreen(drugService: MockDrugService.sample)
    }
}

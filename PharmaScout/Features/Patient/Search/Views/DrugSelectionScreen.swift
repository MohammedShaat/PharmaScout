//
//  SearchScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct DrugSelectionScreen: View {
    let onCompletion: ((SelectedDrug) -> Void)?
    
    @State private var vm: DrugSelectionViewModel
    @FocusState private var isSearchFocused: Bool
    @State private var selectionTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    
    init(drugService: DrugService, editingSelectedDrug: SelectedDrug, selectedFormulationIds: [String]) {
        let viewModel = DrugSelectionViewModel(
            drugSerice: drugService,
            editingSelectedDrug: editingSelectedDrug,
            selectedFormulationIds: selectedFormulationIds
        )
        self._vm = State(wrappedValue: viewModel)
        self.onCompletion = nil
    }
    
    init(drugService: DrugService, selectedFormulationIds: [String], onCompletion: @escaping (SelectedDrug) -> Void) {
        self.onCompletion = onCompletion
        let viewModel = DrugSelectionViewModel(
            drugSerice: drugService,
            editingSelectedDrug: nil,
            selectedFormulationIds: selectedFormulationIds
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            headerSection
            
            selectionChipsSection
            Spacer()
            
            // Search (generic name and formulation selection)
            if !vm.isDrugFormulationSelected {
                searchFieldSection
                
                ScrollView {
                    if !vm.isGenericDrugSelected {
                        genericDrugListSection
                    } else {
                        drugFormulationListSection
                    }
                }
                .refreshable(action: vm.refresh)
            } else {
                // Save
                saveButton
            }
        }
        .padding(DesignSystem.Spacing.xLarge)
        .onAppear {
            isSearchFocused = true
        }
        .task(id: vm.searchText) {
            await vm.onSearchTextChanged()
        }
        .onDisappear {
            selectionTask?.cancel()
        }
    }
    
    private var headerSection: some View {
        SheetHeaderView(title: "Choose medicine") {
            dismiss()
        }
    }
    
    private var searchFieldSection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            SearchFieldView(text: $vm.searchText, placehodler: "Search medicines")
                .focused($isSearchFocused)
            
            HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                Image(systemName: "questionmark.circle")
                    .font(.headline)
                    .foregroundStyle(.theme.success)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(!vm.isGenericDrugSelected ? "Drug name?" : "Formulation?")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.textPrimary)
                    
                    Text(
                        !vm.isGenericDrugSelected
                        ? "Type at least 3 letters to search. For combinations, separate them with any character."
                        : "Type form, strength, or route. Separate terms with any character."
                    )
                    .foregroundStyle(.theme.textLabel)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(background: .theme.mintTint, radius: DesignSystem.CornerRadius.small)
        }
    }
    
    private var genericDrugListSection: some View {
        LoadingContentView(
            LoadingState: vm.searchLoadingState,
            showMessage: vm.genericDrugs.isEmpty && vm.searchText.isNotEmpty,
            emptyMessage: "We couldn't find \"\(vm.searchText)\". Check the spelling or try another medicine name."
        ) {
                CustomLazyList(
                    items: vm.genericDrugs,
                    isLoadingMore: vm.searchLoadingState.status == .loadingMore) { genericDrug in
                        genericDrugItem(genericDrug: genericDrug)
                            .clickable {
                                selectionTask?.cancel()
                                selectionTask = Task {
                                    await vm.onGenericDrugClicked(genericDrug: genericDrug)
                                }
                            }
                            .task(id: genericDrug.id) {
                                if genericDrug.isLast(vm.genericDrugs) {
                                    await vm.loadMore()
                                }
                            }
                    }
            }
    }
    
    private func genericDrugItem(genericDrug: GenericDrug) -> some View {
        Text(genericDrug.genericName)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.theme.textPrimary)
    }
    
    private var drugFormulationListSection: some View {
        LoadingContentView(
            LoadingState: vm.searchLoadingState,
            showMessage: vm.drugFormulations.isEmpty && vm.searchText.isNotEmpty,
            emptyMessage: "We couldn't find any medicine matching your search criteria. Try adjusting the strength, form, or route."
        ) {
                CustomLazyList(
                    items: vm.drugFormulations,
                    isLoadingMore: vm.searchLoadingState.status == .loadingMore
                ) { drugFormulation in
                    drugFormulationsItem(drugFormulation: drugFormulation)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .clickable {
                            selectionTask?.cancel()
                            selectionTask = Task {
                                await vm.onDrugFormulationClicked(drugFormulaion: drugFormulation)
                            }
                        }
                        .task {
                            if drugFormulation.isLast(vm.drugFormulations) {
                                await vm.loadMore()
                            }
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
    }
    
    private func drugFormulationsItem(drugFormulation: DrugFormulation) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(drugFormulation.strength)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            HStack(spacing: DesignSystem.Spacing.medium) {
                Text(drugFormulation.form)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.secondaryStrong)
                    .padding(.vertical, DesignSystem.Spacing.xSmall)
                    .padding(.horizontal, DesignSystem.Spacing.small)
                    .roundedBackground(background: .theme.mintTint, radius: DesignSystem.CornerRadius.small)
                
                Text(drugFormulation.route)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
    }
    
    private var selectionChipsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            if let selectedGenericDrug = vm.selectedGenericDrug {
                ChipView(name: selectedGenericDrug.genericName) {
                    vm.onGenericDrugCanceled()
                }
            }
            if let selectedDrugFormulation = vm.selectedDrugFormulation {
                ChipView(name: "\(selectedDrugFormulation.strength) \n \(selectedDrugFormulation.form) \n \(selectedDrugFormulation.route)") {
                    vm.onDrugFormulationCanceled()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var saveButton: some View {
        PrimaryButtonView(title: vm.editingSelectedDrug == nil ? "Add medicine" : "Save changes") {
            vm.applyChanges()
            if let selectedDrug = vm.createSelctedDrug() {
                onCompletion?(selectedDrug)
            }
            dismiss()
        }
    }
}

#Preview {
    CustomNavStack {
        Text("")
            .sheet(isPresented: .constant(true)) {
                DrugSelectionScreen(drugService: MockDrugService.sample, selectedFormulationIds: []) { _ in
                    
                }
            }
    }
}

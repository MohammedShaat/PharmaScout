
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

@Observable
class DrugSelectionViewModel {
    let drugSerice: DrugService
    let editingSelectedDrug: SelectedDrug?
    let selectedFormulationIds: [String]
    
    var searchText: String = "" {
        didSet { onSearchTextChanged() }
    }
    private var trimmedSearchText: String {
        searchText.trimmed
    }
    private var lastSearchText: String = ""
    
    private(set) var genericDrugs: [GenericDrug] = []
    private(set) var drugFormulations: [DrugFormulation] = []
    
    private(set) var searchLoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
    private(set) var selectedGenericDrug: GenericDrug?
    var isGenericDrugSelected: Bool { selectedGenericDrug != nil }
    
    private(set) var selectedDrugFormulation: DrugFormulation?
    var isDrugFormulationSelected: Bool { selectedDrugFormulation != nil }
    
    init(drugSerice: DrugService, editingSelectedDrug: SelectedDrug?, selectedFormulationIds: [String]) {
        self.drugSerice = drugSerice
        self.editingSelectedDrug = editingSelectedDrug
        self.selectedFormulationIds = selectedFormulationIds
        
        if let editingSelectedDrug {
            self.selectedGenericDrug = editingSelectedDrug.genericDrug
            self.selectedDrugFormulation = editingSelectedDrug.formulation
        }
    }
    
    func search() async {
        if isGenericDrugSelected {
            await searchDrugFormulations()
        } else {
            await searchDrugName()
        }
    }
    
    func onGenericDrugClicked(genericDrug: GenericDrug) async {
        selectedGenericDrug = genericDrug
        searchText = ""
    }
    
    func onDrugFormulationClicked(drugFormulaion: DrugFormulation) async {
        selectedDrugFormulation = drugFormulaion
    }
    
    func onGenericDrugCanceled() {
        resetDrugForumationSelection()
        resetSelection()
    }
    
    func onDrugFormulationCanceled() {
        resetDrugForumationSelection()
    }
    
    func loadMore() async {
        await search()
    }
    
    func refresh() async {
        searchLoadingState.pagination.reset()
        searchLoadingState.startLoading(refresh: true)
        await search()
    }
    
    func applyChanges() {
        guard let genericDrug = selectedGenericDrug,
            let formulation = selectedDrugFormulation,
            let editingSelectedDrug = editingSelectedDrug
        else { return }
        
        editingSelectedDrug.genericDrug = genericDrug
        editingSelectedDrug.formulation = formulation
    }
    
    func createSelctedDrug() -> SelectedDrug? {
        guard let genericDrug = selectedGenericDrug,
          let formulation = selectedDrugFormulation
        else { return nil }
        
        return SelectedDrug(from: genericDrug, and: formulation)
    }
    
    private func searchDrugName() async {
        await paginationHandler {
            try await drugSerice.searchGenericDrug(
                contains: trimmedSearchText,
                from: searchLoadingState.pagination.from,
                to: searchLoadingState.pagination.to
            )
            
        } onSuccess: { newGenericDrugs in
            if searchLoadingState.pagination.hasPreviousPage {
                genericDrugs.append(contentsOf: newGenericDrugs)
            } else {
                genericDrugs = newGenericDrugs
            }
        }

    }
    
    private func searchDrugFormulations() async {
        guard let selectedGenericDrug else { return }
        
        await paginationHandler(allowEmpty: true) {
            try await drugSerice.searchDrugFormulations(
                of: selectedGenericDrug.id,
                contians: trimmedSearchText,
                from: searchLoadingState.pagination.from,
                to: searchLoadingState.pagination.to
            )
            
        } onSuccess: { newDrugFormulations in
            
            let newUnselectedDrugFormulations = newDrugFormulations.filter {
                !selectedFormulationIds.contains($0.id)
            }
            
            if searchLoadingState.pagination.hasPreviousPage {
                drugFormulations.append(contentsOf: newUnselectedDrugFormulations)
            } else {
                drugFormulations = newUnselectedDrugFormulations
            }
        }
    }
    
    private func resetSelection() {
        genericDrugs.removeAll()
        drugFormulations.removeAll()
        searchText = selectedGenericDrug?.genericName ?? ""
        selectedGenericDrug = nil
    }
    
    private func resetDrugForumationSelection() {
        drugFormulations.removeAll()
        searchText = selectedDrugFormulation?.title ?? ""
        selectedDrugFormulation = nil
    }

    private func onSearchTextChanged() {
        searchLoadingState.pagination.reset()
    }
}

extension DrugSelectionViewModel {
    private func isSearchValid(allowEmpty: Bool = false) -> Bool {
        (trimmedSearchText != lastSearchText && (trimmedSearchText.count >= 3 || allowEmpty))
        || searchLoadingState.pagination.hasPreviousPage
        || searchLoadingState.status == .refreshing
    }
    
    private func paginationHandler<T: Collection>(
        allowEmpty: Bool = false,
        asyncWork: () async throws -> T,
        onSuccess: (T) -> Void
    ) async {
        guard isSearchValid(allowEmpty: allowEmpty) else { return }
        
        defer { searchLoadingState.stopLoading() }
        
        do {
            if !searchLoadingState.pagination.hasPreviousPage && searchLoadingState.status != .refreshing {
                try await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
            }
            if searchLoadingState.status != .refreshing {
                searchLoadingState.startLoading()
            }
            
            let result = try await asyncWork()
            
            lastSearchText = trimmedSearchText
            if result.isNotEmpty {
                searchLoadingState.pagination.nextPage()
            }
            
            onSuccess(result)
        } catch {
            searchLoadingState.fail(error)
            print(error)
        }
    }
}



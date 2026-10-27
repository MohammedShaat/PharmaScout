
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
    
    var searchText: String = ""
    private var trimmedSearchText: String {
        searchText.trimmed
    }
    private var lastSearchText: String?
    
    private(set) var genericDrugs: [GenericDrug] = []
    private(set) var drugFormulations: [DrugFormulation] = []
    
    var searchLoadingState = LoadingState(pageSize: AppConstants.Network.pageSize)
    
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
    
    func onSearchTextChanged() async {
        searchLoadingState.pagination.reset()
        await search()
    }
    
    private func search() async {
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
            
            let newNonselectedDrugFormulations = newDrugFormulations.filter { newFormulation in
                !selectedFormulationIds.contains(newFormulation.id) || editingSelectedDrug?.formulation.id == newFormulation.id
            }
            
            if searchLoadingState.pagination.hasPreviousPage {
                drugFormulations.append(contentsOf: newNonselectedDrugFormulations)
            } else {
                drugFormulations = newNonselectedDrugFormulations
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
}

extension DrugSelectionViewModel {
    private func paginationHandler<T: Collection>(
        allowEmpty: Bool = false,
        asyncWork: () async throws -> T,
        onSuccess: (T) -> Void
    ) async {
        let shouldPerform = SearchRequestPolicy.shouldPerform(
            query: searchText,
            lastQuery: lastSearchText,
            allowsEmptyQuery: allowEmpty,
            hasPreviousPage: searchLoadingState.pagination.hasPreviousPage,
            isRefreshing: searchLoadingState.status == .refreshing
        )
        
        await SearchRequestPolicy.perform(
            shouldPerform: shouldPerform,
            hasPreviousPage: searchLoadingState.pagination.hasPreviousPage,
            isRefreshing: searchLoadingState.status == .refreshing,
            stopLoading: {
                searchLoadingState.stopLoading()
            },
            startLoading: {
                if searchLoadingState.status != .refreshing {
                    searchLoadingState.startLoading()
                }
            },
            advancePage: {
                searchLoadingState.pagination.nextPage()
            },
            handleError: { error in
                searchLoadingState.fail(error)
                print("Failed to search\n", error)
            },
            query: searchText,
            updateLastQuery: {
                lastSearchText = searchText
            },
            asyncWork: asyncWork,
            onSuccess: onSuccess
        )
    }
}



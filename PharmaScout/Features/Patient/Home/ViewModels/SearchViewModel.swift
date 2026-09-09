
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

@Observable
class SearchViewModel {
    let drugSerice: DrugService
    
    var searchText: String = "" {
        didSet { onSearchTextChanged() }
    }
//    var searchText: String = "a"
    private var trimmedSearchText: String {
        searchText.trimmed
    }
    private var lastSearchText: String = ""
    
    private(set) var genericDrugs: [GenericDrug] = []
    private(set) var drugFormulations: [DrugFormulation] = []
    
    var searchError: AppError?
    private(set) var isLoading: Bool = false
    
    private(set) var selectedGenericDrug: GenericDrug?
//    private(set) var selectedGenericDrug: GenericDrug? = .samples[0]
    var isGenericDrugSelected: Bool { selectedGenericDrug != nil }
    
    private(set) var selectedDrugFormulation: DrugFormulation?
    var isDrugFormulationSelected: Bool { selectedDrugFormulation != nil }
    
    private let pageSize = 5
    private var page = 0
    private var from: Int { page * pageSize }
    private var to: Int { from + pageSize - 1 }
    private(set) var paginating: Bool = false
    
    private(set) var refreshing = false
    
    init(drugSerice: DrugService) {
        self.drugSerice = drugSerice
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
        paginating = true
        await search()
    }
    
    func refresh() async {
        resetPagination()
        refreshing = true
        await search()
        refreshing = false
    }
    
    private func searchDrugName() async {
        await paginationHandler {
            try await drugSerice.searchGenericDrug(contains: trimmedSearchText, from: from, to: to)
        } onSuccess: { newGenericDrugs, paginated in
            if paginated {
                genericDrugs.append(contentsOf: newGenericDrugs)
            } else {
                genericDrugs = newGenericDrugs
            }
        }

    }
    
    private func searchDrugFormulations() async {
        guard let selectedGenericDrug else { return }
        
        await paginationHandler(allowEmpty: true) {
            try await drugSerice.searchDrugFormulations(of: selectedGenericDrug.id, contians: trimmedSearchText, from: from, to: to)
        } onSuccess: { newDrugFormulations, paginated in
            if paginated {
                drugFormulations.append(contentsOf: newDrugFormulations)
            } else {
                drugFormulations = newDrugFormulations
            }
        }
    }
    
    private func paginationHandler<T>(
        allowEmpty: Bool = false,
        asyncWork: () async throws -> [T],
        onSuccess: ([T], Bool) -> Void
    ) async {
        guard isSearchValid(allowEmpty: allowEmpty) else { return }
        
        do {
            if !paginating {
                try await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
            }
            isLoading = true
            
            let resultArray = try await asyncWork()
            
            lastSearchText = trimmedSearchText
            if resultArray.isNotEmpty {
                page += 1
            }
            onSuccess(resultArray, paginating)
            
        } catch {
            searchError = ErrorHandler.handle(error)
            print(error)
        }
        
        isLoading = false
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
        resetPagination()
    }
    
    private func resetPagination() {
        page = 0
        paginating = false
    }
}

extension SearchViewModel {
    private func isSearchValid(allowEmpty: Bool = false) -> Bool {
        (trimmedSearchText != lastSearchText && (trimmedSearchText.count >= 3 || allowEmpty))
        || paginating
        || refreshing
    }
}

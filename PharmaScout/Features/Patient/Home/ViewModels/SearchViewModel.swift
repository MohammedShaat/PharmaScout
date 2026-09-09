//
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

@Observable
class SearchViewModel {
    let drugSerice: DrugService
    
    var searchText: String = ""
    private var trimmedSearchText: String {
        searchText.trimmed
    }
    private var lastSearchText: String = ""
    
    private(set) var genericDrugs: [GenericDrug] = []
    
    var searchError: AppError?
    private(set) var isLoading: Bool = false
    
    init(drugSerice: DrugService) {
        self.drugSerice = drugSerice
    }
    
    func autoComplete() async {
        guard isSearchTextValid() else { return }
        
        do {
            try await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
            isLoading = true
            
            genericDrugs = try await drugSerice.autoComplete(for: trimmedSearchText)
            lastSearchText = trimmedSearchText
            
        } catch {
            searchError = ErrorHandler.handle(error)
            print("Failed to fetch generic drugs\n\(error)")
        }
        
        isLoading = false
    }
}

extension SearchViewModel {
    private func isSearchTextValid() -> Bool {
        trimmedSearchText != lastSearchText
        && trimmedSearchText.count >= 3
    }
}

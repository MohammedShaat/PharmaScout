//
//  SearchViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import Foundation

@Observable
class SearchViewModel {
    private(set) var selectedDrugs: [SelectedDrug] = []
    var reachedLimit: Bool { selectedDrugs.count == AppConstants.Search.maxDrugsPerRequest }
    
    var acceptSubstitutes: Bool = true
    var fulfilmentMode: FulfilmentMode = .singlePharmacy
    
    init() {
        
    }
    
    func addDrug(selectedDrug: SelectedDrug) {
        selectedDrugs.append(selectedDrug)
    }
    
    func cancelDrug(id: String) {
        selectedDrugs.removeAll {
            $0.id == id
        }
    }
}

enum FulfilmentMode: String, CaseIterable, Identifiable {
    case singlePharmacy = "single_pharmacy"
    case multiPharmacy = "multi_pharmacy"
    
    var id: Self { self }
}

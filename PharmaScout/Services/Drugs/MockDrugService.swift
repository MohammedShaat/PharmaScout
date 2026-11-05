//
//  MockDrugService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

struct MockDrugService: DrugService {
    func searchGenericDrug(contains text: String, from: Int, to: Int) async throws -> [GenericDrug] {
        
        try? await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
        
        return GenericDrug.samples.filter {
            $0.genericName.localizedCaseInsensitiveContains(text)
        }
    }
    
    func searchDrugFormulations(of genericDrugId: String, contians searchText: String, from: Int, to: Int) async throws -> [DrugFormulation] {
        
        try? await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
        
        let allFormulations = DrugFormulation.samples.filter {
            $0.genericDrugId == genericDrugId
        }
        
        let start = min(max(from, 0), allFormulations.count)
        let end = min(max(to, 0), allFormulations.count)
        guard start < end else { return [] }
        
        return Array(allFormulations[start..<end])
    }
}

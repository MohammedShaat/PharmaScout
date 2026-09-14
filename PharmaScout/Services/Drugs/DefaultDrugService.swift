//
//  DefaultDrugService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation
import Supabase

struct DefaultDrugService: DrugService {
    private let supabase = SupabaseManager.shared.client
    
    func searchGenericDrug(contains text: String, from: Int, to: Int) async throws -> [GenericDrug] {
        do {
            let searchGenericDrugFunc = SupabaseManager.Database.Functions.SearchGenericDrug.self
            let params = searchGenericDrugFunc.Params
            
            let genericDrugs: [GenericDrug] = try await supabase
                .rpc(
                    searchGenericDrugFunc.name,
                    params: [params.inputText: text]
                )
                .range(from: from, to: to)
                .execute()
                .value
            
            return genericDrugs
            
        } catch  {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func searchDrugFormulations(of genericDrugId: String, contians searchText: String, from: Int, to: Int) async throws -> [DrugFormulation] {
        do {
            let searchDrugFormulationsFunc = SupabaseManager.Database.Functions.SearchDrugFormulations.self
            let params = searchDrugFormulationsFunc.Params
            
            let drugFormulations: [DrugFormulation] = try await supabase
                .rpc(
                    searchDrugFormulationsFunc.name,
                    params: [
                        params.genericDrugId: genericDrugId,
                        params.inputText: searchText
                    ]
                )
                .range(from: from, to: to)
                .execute()
                .value
            
            return drugFormulations
            
        } catch  {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}


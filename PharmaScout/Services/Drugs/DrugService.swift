//
//  DrugService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import Foundation

protocol DrugService {
    func searchGenericDrug(contains text: String, from: Int, to: Int) async throws -> [GenericDrug]
    
    func searchDrugFormulations(of genericDrugId: String, contians searchText: String, from: Int, to: Int) async throws -> [DrugFormulation]
}

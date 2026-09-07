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
    private let db = SupabaseManager.Database.self
    
//    func autoComplete(for text: String) async throws -> [GenericDrug] {
//        do {
//            let genericDrug = Table.GenericDrug.self
//            let column = Table.GenericDrug.Column.self
//            
//            let genericDrugs: [GenericDrug] = try await supabase.from(genericDrug.name)
//                .select()
//                .ilike(column.genericName, pattern: "%\(text)%")
//                .execute()
//                .value
//            
//            return genericDrugs
//            
//        } catch let error as PostgrestError {
//            print(error)
//            throw error
//            
//        } catch let error as URLError {
//            throw NetworkError(from: error)
//        }
//    }
    
//    func autoComplete(for text: String) async throws -> [GenericDrug] {
//        do {
//            let genericDrug = Table.GenericDrug.self
//            let column = Table.GenericDrug.Column.self
//            
//            var query = supabase.from(genericDrug.name)
//                .select()
//            let normalizedText = text.replacing("/[^a-zA-Z]+/", with: " ")
//            let words = normalizedText.components(separatedBy: " ")
//            for word in words {
//                query = query.or(
//                    "\(column.genericName).ilike.\(word)%,\(column.genericName).ilike.% \(word)%"
//                )
//            }
//            
//            let genericDrugs: [GenericDrug] = try await query.execute().value
//            return genericDrugs
//            
//        } catch let error as PostgrestError {
//            print(error)
//            throw error
//            
//        } catch let error as URLError {
//            throw NetworkError(from: error)
//        }
//    }
    
    func autoComplete(for text: String) async throws -> [GenericDrug] {
        do {
            let searchGenericDrug = SupabaseManager.Functions.SearchGenericDrug.self
            let params = searchGenericDrug.Params
            
            let genericDrugs: [GenericDrug] = try await supabase
                .rpc(
                    searchGenericDrug.name,
                    params: [params.inputText: text]
                )
                .execute()
                .value
            
            return genericDrugs
            
        } catch let error as PostgrestError {
            print(error)
            throw error
            
        } catch let error as URLError {
            throw NetworkError(from: error)
        }
    }
}

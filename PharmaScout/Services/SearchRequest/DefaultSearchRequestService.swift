//
//  DefaultSearchRequestService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/14/26.
//

import Foundation
import Supabase

struct DefaultSearchRequestService: SearchRequestService {
    private let supabase = SupabaseManager.shared.client
    
    func createSearchRequest(request: SearchRequest) async throws {
        let createSeachFunc = SupabaseManager.Database.Functions.CreateSearch.self
        
        do {
            try await supabase
                .rpc(createSeachFunc.name, params: request)
                .execute()
                .value
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getNumberOfActiveSearchs(userId: String) async throws -> Int {
        let searchTable = SupabaseManager.Database.Table.Search.self
        let column = searchTable.Column
        
        do {
            let count = try await supabase
                .from(searchTable.name)
                .select(head: true, count: .exact)
                .eq(column.userId, value: userId)
                .eq(column.status, value: SearchStatus.pending.rawValue)
                .execute()
                .count
            
            return count ?? 0
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getSearches(_ params: GetSearchesParams) async throws -> [Search] {
        let getSearchesFunc = SupabaseManager.Database.Functions.getSearches.self
        
        do {
            let searchs: [Search] = try await supabase
                .rpc(getSearchesFunc.name, params: params)
                .execute()
                .value
            
            return searchs
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getSearchDrugDetails(_ params: SearchDrugDetailsParams) async throws -> [SearchDrugDetail] {
        let getSearchDrugDetailsFunc = SupabaseManager.Database.Functions.getSearchDrugDetails.self

        do {
            let searchs: [SearchDrugDetail] = try await supabase
                .rpc(getSearchDrugDetailsFunc.name, params: params)
                .execute()
                .value
            
            return searchs
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

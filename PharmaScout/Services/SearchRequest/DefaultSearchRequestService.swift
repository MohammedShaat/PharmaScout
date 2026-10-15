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
            let searches: [Search] = try await supabase
                .rpc(getSearchesFunc.name, params: params)
                .execute()
                .value
            
            return searches
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getSearch(for searchId: String) async throws -> Search {
        let getSearchFunc = SupabaseManager.Database.Functions.getSearch.self
        let params = getSearchFunc.Params.self
        
        do {
            let search: Search = try await supabase
                .rpc(
                    getSearchFunc.name,
                    params: [params.searchId: searchId]
                )
                .single()
                .execute()
                .value
            
            return search
            
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
    
    func continueSearch(request: ContinueSearchRequest) async throws -> Int {
        let continueSearchFunc = SupabaseManager.Database.Functions.continueSearch.self
        
        do {
            let pharmacyCount: Int = try await supabase
                .rpc(continueSearchFunc.name, params: request)
                .single()
                .execute()
                .value
            
            return pharmacyCount
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

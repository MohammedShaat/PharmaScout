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
}

//
//  QuerySearchRunner.swift
//  PharmaScout
//
//  Created by Mohammed on 10/12/26.
//

import Foundation

enum QuerySearchRunner {
    static func shouldPerform(
        query: String,
        lastQuery: String?,
        allowsEmptyQuery: Bool = false,
        hasPreviousPage: Bool,
        isRefreshing: Bool
    ) -> Bool {
        let minimumQueryLength: Int = AppConstants.Search.minimumQueryLength
        let query = query.trimmed.lowercased()
        let lastQuery = lastQuery?.trimmed.lowercased()
        
        let queryChanged = lastQuery == nil || query.lowercased() != lastQuery?.lowercased()
        let meetsMinimumLength = query.trimmed.count >= minimumQueryLength
        let queryIsValid = queryChanged && meetsMinimumLength
        
        let emptyQueryIsAllowed = allowsEmptyQuery && query.isEmpty && queryChanged

        return queryIsValid
            || emptyQueryIsAllowed
            || hasPreviousPage
            || isRefreshing
    }
    
    @MainActor
    static func perform<T: Collection>(
        shouldPerform: Bool,
        hasPreviousPage: Bool,
        isRefreshing: Bool,
        stopLoading: () -> Void,
        startLoading: () -> Void,
        advancePage: () -> Void,
        handleError: (Error) -> Void,
        query: String,
        updateLastQuery: () -> Void,
        asyncWork: () async throws -> T,
        onSuccess: (T) -> Void
    ) async {
        guard shouldPerform else { return }
        
        defer { stopLoading() }
        
        do {
            if !hasPreviousPage && !isRefreshing {
                try await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
            }
            
            if !Task.isCancelled {
                startLoading()
                
                let result = try await asyncWork()
                
                updateLastQuery()
                
                onSuccess(result)

                if result.isNotEmpty {
                    advancePage()
                }
            }
            
        } catch {
            handleError(error)
        }
    }
    
    static func perform(
        shouldPerform: Bool,
        hasPreviousPage: Bool,
        isRefreshing: Bool,
        startLoading: () -> Void,
        query: String,
        updateLastQuery: () -> Void,
        work: () -> Void,
    ) async {
        guard shouldPerform else { return }
        
        if !hasPreviousPage && !isRefreshing {
            try? await Task.sleep(for: AppConstants.Timing.searchDebounceInterval)
        }
        
        if !Task.isCancelled {
            startLoading()
            
            work()
            
            updateLastQuery()
        }
        
    }
}

//
//  SearchRequest.swift
//  PharmaScout
//
//  Created by Mohammed on 10/12/26.
//

import Foundation

enum SearchRequestPolicy {
    static func shouldPerform(
        query: String,
        lastQuery: String,
        minimumQueryLength: Int = 3,
        allowsEmptyQuery: Bool = false,
        hasPreviousPage: Bool,
        isRefreshing: Bool
    ) -> Bool {
        let queryChanged = query.trimmed.lowercased() != lastQuery.trimmed.lowercased()
        let meetsMinimumLength = query.count >= minimumQueryLength
        let queryIsValid = queryChanged && meetsMinimumLength
        
        let emptyQueryIsAllowed = allowsEmptyQuery && query.isEmpty

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
            
            startLoading()
            
            let result = try await asyncWork()
            
            updateLastQuery()
            
            onSuccess(result)

            if result.isNotEmpty {
                advancePage()
            }
            
        } catch {
            handleError(error)
        }
    }
}

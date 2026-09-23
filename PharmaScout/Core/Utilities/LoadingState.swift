//
//  LoadingState.swift
//  PharmaScout
//
//  Created by Mohammed on 9/153/26.
//


import Foundation

struct LoadingState {
    var status: State = .idle
    var pagination: Pagination
    
    init(pageSize: Int) {
        pagination = .init(pageSize: pageSize)
    }
    
    mutating func startLoading(refresh: Bool = false) {
        if refresh {
            status = .refreshing
        } else {
            status = pagination.page != 0 ? .loadingMore : .loading
        }
    }
    
    mutating func stopLoading() {
        status = .idle
    }
    
    enum State {
        case idle
        case loading
        case loadingMore
        case refreshing
    }
}


extension LoadingState {
    struct Pagination {
        let pageSize: Int
        private(set) var page = 0
        
        var from: Int { page * pageSize }
        var to: Int { from + pageSize - 1 }
        
        var hasPreviousPage: Bool { page > 1 }
        
        init(pageSize: Int) {
            self.pageSize = pageSize
        }
        
        mutating func nextPage() {
            page += 1
        }
        
        mutating func reset() {
            page = 0
        }
    }
}

//
//  Pagination.swift
//  PharmaScout
//
//  Created by Mohammed on 9/153/26.
//


import Foundation

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

//
//  ArrayOfString+Joined.swift
//  PharmaScout
//
//  Created by Mohammed on 11/2/26.
//

import Foundation

extension Collection where Element == String {
    func joinedWithOr() -> String {
        enumerated().map { index, item in
            index == count - 1 ? "or \(item)" : "\(item), "
        }.joined(separator: "")
    }
}

//
//  Identifiable+IsLast.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import Foundation

extension Identifiable {
    func isLast<I: Identifiable>(_ array: Array<I>) -> Bool where I.ID == Self.ID {
        id == array.last?.id
    }
}

//
//  Collection+DoesNotContain.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

extension Collection where Element: Equatable {
    func doesNotContain(_ element: Element) -> Bool {
        !contains(element)
    }
}

//
//  ResolvedPlace.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

struct ResolvedPlace: Equatable, Sendable {
    let suggestedAddress: String?
    let timeZone: TimeZone?

    static let empty = ResolvedPlace(suggestedAddress: nil, timeZone: nil)
}

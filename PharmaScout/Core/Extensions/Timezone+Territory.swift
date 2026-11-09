//
//  Timezone+FromGMT.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import Foundation

extension TimeZone {
    var territory: String? {
        identifier
            .components(separatedBy: "/")
            .last?
            .replacingOccurrences(of: "_", with: " ")
    }
}

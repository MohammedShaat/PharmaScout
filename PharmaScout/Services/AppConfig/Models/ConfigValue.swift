//
//  ConfigValue.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation

struct ConfigValue: nonisolated Decodable {
    let key: String
    let value: String
}

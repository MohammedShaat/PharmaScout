//
//  JoinCode.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import Foundation

struct JoinCode: nonisolated Codable {
    let code: String
    let expiresAt: Date
}

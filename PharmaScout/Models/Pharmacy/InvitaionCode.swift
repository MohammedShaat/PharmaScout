//
//  JoinCode.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import Foundation

struct InvitaionCode: nonisolated Codable {
    let code: String
    let expiresAt: Date
}

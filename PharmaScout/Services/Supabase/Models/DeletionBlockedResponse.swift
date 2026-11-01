//
//  DeletionBlockedResponse.swift
//  PharmaScout
//
//  Created by Mohammed on 10/31/26.
//

import Foundation

struct DeletionBlockedResponse: Decodable {
    let error: String
    let blockers: [String]
}

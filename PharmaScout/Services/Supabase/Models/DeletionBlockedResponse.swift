//
//  DeletionBlockedResponse.swift
//  PharmaScout
//
//  Created by Mohammed on 10/31/26.
//

import Foundation

struct DeleteAccountBodyResponse: Codable {
    let error: String
    let providers: [String]?
    let blockers: [AccountDeletionBlocker]?
}

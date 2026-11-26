//
//  InvitationCode.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

extension InvitationCode {
    static let sample: InvitationCode = {
        let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return InvitationCode(code: "A7K2M9", expiresAt: expirationDate)
    }()
}

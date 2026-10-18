//
//  InvitationCode.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

extension InvitaionCode {
    static let sample: InvitaionCode = {
        let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return InvitaionCode(code: "A7K2M9", expiresAt: expirationDate)
    }()
}

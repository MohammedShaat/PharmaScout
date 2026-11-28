//
//  OwnerApplicationSummary+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

extension OwnerApplicationSummary {
    static let samples = [
        OwnerApplicationSummary(
            id: OwnerApplication.samples[1].id,
            status: .approved
        ),
        OwnerApplicationSummary(
            id: OwnerApplication.samples[2].id,
            status: .pending
        ),
        OwnerApplicationSummary(
            id: OwnerApplication.samples[3].id,
            status: .rejected
        ),
    ]
}

//
//  OwnerApplicantHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import Foundation

@Observable
class OwnerApplicantHomeViewModel {
    let ownerApplicationSummary: OwnerApplicationSummary
    private let ownerApplicationService: OwnerApplicationService
    
    init(ownerApplicationSummary: OwnerApplicationSummary, ownerApplicationService: OwnerApplicationService) {
        self.ownerApplicationSummary = ownerApplicationSummary
        self.ownerApplicationService = ownerApplicationService
    }
}

//
//  AdminTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class AdminTabViewModel {
    var selectedTab: AdminTab = .ownerApplications
}

enum AdminTab {
    case ownerApplications
    case pharmacies
    case invite
    case profile
}

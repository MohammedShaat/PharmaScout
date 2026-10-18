//
//  AdminTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class AdminTabViewModel {
    var selectedTab: AdminTab = .applications
}

enum AdminTab {
    case applications
    case invite
    case profile
}

//
//  AdminTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class AdminTabViewModel {
    var selectedTab: AdminTab = .home
}

enum AdminTab {
    case home
    case invitation
    case profile
}

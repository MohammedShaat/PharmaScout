//
//  HomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class HomeViewModel {
    private(set) var userName: String = "Mohammed"
    var hasUnreadNotifications: Bool = true
}

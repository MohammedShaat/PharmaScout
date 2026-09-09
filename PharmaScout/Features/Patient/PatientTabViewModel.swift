//
//  PatientTabViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/6/26.
//

import Foundation

@Observable
class PatientTabViewModel {
    var selectedTab: PatientTab = .home
    
}

enum PatientTab {
    case home
    case recent
    case pharmacies
    case profile
}

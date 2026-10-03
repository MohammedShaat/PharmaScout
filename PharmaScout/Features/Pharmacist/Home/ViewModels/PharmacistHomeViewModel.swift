//
//  PharmacistHomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

@Observable
class PharmacistHomeViewModel {
    private let authService: AuthService
    
    var isAuthorized: Bool {
        authService.authSession?.pharmacyStaff?.status == .approved
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
}

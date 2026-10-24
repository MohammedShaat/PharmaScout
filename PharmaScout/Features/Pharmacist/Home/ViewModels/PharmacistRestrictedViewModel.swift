//
//  PharmacistHomeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

@Observable
class PharmacistRestrictedViewModel {
    private let authService: AuthService
    
    var user: AppUser? { authService.authSession?.user }
    
    var hasUnreadNotifications: Bool = true
    
    private(set) var authSessionLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func refresh() async {
        await refreshAuthSession()
    }
    
    func refreshAuthSession() async {
        authSessionLoadingState.startLoading(refresh: true)
        defer { authSessionLoadingState.stopLoading() }
        
        do {
            try await authService.refreshAuthSession()
            
        } catch {
            authSessionLoadingState.fail(error)
            print("Failed to refresh auth session\n", error)
        }
    }
}

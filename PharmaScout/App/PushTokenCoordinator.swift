//
//  PushTokenCoordinator.swift
//  PharmaScout
//
//  Created by Mohammed on 10/13/26.
//

import Foundation

class PushTokenCoordinator {
    private let deviceTokenService: DeviceTokenService
    
    private var token: String?
    private var isAuthenticated: Bool = false
    
    init(deviceTokenService: DeviceTokenService) {
        self.deviceTokenService = deviceTokenService
    }
    
    func observeToken(_ tokens: AsyncStream<String>) async {
        for await token in tokens {
            self.token = token
            await registerIfPossible()
        }
    }
    
    func observeAuthState(_ authStates: AsyncStream<AuthState>) async {
        for await authState in authStates {
            if case .authenticated = authState {
                self.isAuthenticated = true
                await registerIfPossible()
                
            } else {
                self.isAuthenticated = false
            }
        }
    }
    
    private func registerIfPossible() async {
        guard let token, isAuthenticated else  { return }
        
        do {				
            try await deviceTokenService.register(token: token)
            
        } catch {
            print("Device token registration failed\n", error)
        }
    }
    
    func willSignOut() async {
        guard let token, isAuthenticated else  { return }
        
        do {
            try await deviceTokenService.unregister(token: token)
            
        } catch {
            print("Device token unregistration failed\n", error)
        }
    }
}


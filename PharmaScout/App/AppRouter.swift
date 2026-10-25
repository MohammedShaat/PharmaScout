//
//  AppRouter.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//

import Foundation
import Supabase
import GoogleSignIn

@Observable
class AppRouter {
    private let authService: AuthService
    private(set) var destination: Destination = .loading
    
    private(set) var authState: AuthState?
    private(set) var authSession: AuthSession?
    
    private(set) var pendingNotificationRoute: NotificationRoute?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func handleUrl(_ url: URL) async {
        if GIDSignIn.sharedInstance.handle(url) {
            return
        }
        
        guard url.scheme == DeepLink.scheme,
              let deepLink = DeepLink(rawValue: (url.host() ?? "") + url.path())
        else {
            print("DeepLink-url is invalid\n", url)
            return
        }
        
        switch deepLink {
        case .emailConfirmation:
            try? await authService.handle(url: url, passwordReset: false)
        
        case .passwordReset:
            try? await authService.handle(url: url, passwordReset: true)
        }
    }
    
    func subscribeToAuthStateChanges() async {
        for await state in authService.authState {
            
            authState = state
            authSession = authService.authSession
            
            if state.invalidatesPendingNotificationRoute {
                pendingNotificationRoute = nil
            }

            destination = destination(for: state)
        }
    }
    
    func observeNotificationRoute(_ notificationRouteStream: AsyncStream<NotificationRoute>) async {
        for await route in notificationRouteStream {
            pendingNotificationRoute = route
        }
    }
    
    func consumePendingPatientNotificationRoute() -> PatientNotificationRoute? {
        defer { pendingNotificationRoute = nil }
        guard case .patient(let route) = pendingNotificationRoute else { return nil }
        return route
    }
    
    func consumePendingPharmacistNotificationRoute() -> PharmacistNotificationRoute? {
        defer { pendingNotificationRoute = nil }
        guard case .pahrmacist(let route) = pendingNotificationRoute else { return nil }
        return route
    }
    
    func onPasswordResetSucceeed() {
        if let authState {
            destination = destination(for: authState)
        }
    }
    
    func navigateToSignIn() {
        destination = .signIn
    }
    
    private func destination(for state: AuthState) -> Destination {
        switch state {
        case .authenticated:
            switch authSession?.accountState {
            case .patient: .patient
            case .pharmacist(let staffMembership): .pharmacist(staffMembership)
            case .admin: .admin
            case .ownerApplicant(let ownerApplicationSummary): .ownerApplicant(ownerApplicationSummary)
            case nil: .authenticationFailure(AppAuthError.sessionMissing.errorDescription)
            }
            
        case .non: .authenticationFlow
        case .signedOut: .signIn
        case .passwordReset: .resetPassword
        case .failed(let error): .authenticationFailure(error.localizedDescription)
        }
    }
}

enum Destination: Equatable {
    case loading
    case authenticationFlow
    case signIn
    case resetPassword
    case authenticationFailure(String?)
    case patient
    case pharmacist(StaffMembership)
    case admin
    case ownerApplicant(OwnerApplicationSummary)
}

extension AuthState {
    var invalidatesPendingNotificationRoute: Bool {
        switch self {
        case .non, .signedOut: true
        case .authenticated, .passwordReset, .failed: false
        }
    }
}

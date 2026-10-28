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
        for await state in await authService.authStateStream() {
            if state.invalidatesPendingNotificationRoute {
                pendingNotificationRoute = nil
            }
            destination = destination(state: state)
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
    
    func navigateToSignIn() {
        destination = .signIn
    }
    
    private func destination(state: AuthState) -> Destination {
        switch state {
        case .authenticated(let authSession):
            switch authSession.accountState {
            case .patient: return .patient(authSession.user)
            case .pharmacist(let staffMembership): return .pharmacist(authSession.user, staffMembership)
            case .admin: return .admin(authSession.user)
            case .ownerApplicant(let ownerApplicationSummary): return .ownerApplicant(authSession.user, ownerApplicationSummary)
            }
            
        case .non: return .authenticationFlow
        case .signedOut: return .signIn
        case .passwordReset: return .resetPassword
        case .failed(let error): return .authenticationFailure(error.localizedDescription)
        }
    }
}

enum Destination: Equatable {
    case loading
    case authenticationFlow
    case signIn
    case resetPassword
    case authenticationFailure(String?)
    case patient(AppUser)
    case pharmacist(AppUser, StaffMembership)
    case admin(AppUser)
    case ownerApplicant(AppUser, OwnerApplicationSummary)
}

extension AuthState {
    var invalidatesPendingNotificationRoute: Bool {
        switch self {
        case .non, .signedOut: true
        case .authenticated, .passwordReset, .failed: false
        }
    }
}

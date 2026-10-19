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
        print("DeepLink-", deepLink)
    }
    
    func subscribeToAuthStateChanges() async {
        for await state in authService.authState {
            
            authSession = authService.authSession

            switch state {
            // MARK: Authenticated
            case .authenticated:
                switch authSession?.accountState {
                case .patient:
                    destination = .patient
                    
                case .pharmacist(let staffMembership):
                    destination = .pharmacist(staffMembership)
                    
                case .admin:
                    destination = .admin
                    
                case .ownerApplicant(let ownerApplicationSummary):
                    destination = .ownerApplicant(ownerApplicationSummary)
                    
                case nil:
                    destination = .authenticationFailure(AppAuthError.sessionMissing)
                }
                
            // MARK: Unauthenticated
            case .non:
                destination = .authenticationFlow
                pendingNotificationRoute = nil
                
            // MARK: Passwrod reset
            case .passwordReset:
                destination = .resetPassword
                
            // MARK: Error
            case .failed(let error):
                destination = .authenticationFailure(error)
            }
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
        destination = .patient
    }
    
    func navigateToSignIn() {
        destination = .signIn
    }
}

enum Destination {
    case loading
    case authenticationFlow
    case signIn
    case resetPassword
    case authenticationFailure(Error)
    case patient
    case pharmacist(StaffMembership)
    case admin
    case ownerApplicant(OwnerApplicationSummary)
}

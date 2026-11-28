//
//  AccountActionsViewModelTests.swift
//  PharmaScoutTests
//
//  Created by Mohammed on 11/23/26.
//

import Testing
@testable import PharmaScout
import Foundation
import UIKit

@MainActor
struct AccountActionsViewModelTests {
    private let vc: UIViewController = .init()
    
    @Test func `Logout unregisters the device token and signs out the user`() async throws {
        let fixture = Fixture()
        await fixture.signIn()
        
        assertUserSignedIn(fixture)
        await fixture.vm.logout()
        
        #expect(fixture.deviceTokens.token == nil)
        #expect(fixture.authService.isSignedIn == false)
    }

    @Test func `Apple user automatically displays Sign in With Apple sheet then deletes`() async throws {
        let usedProviders: [AuthProvider] = [.apple, .google]
        let fixture = Fixture(providers: usedProviders)
        await fixture.signIn()
        assertUserSignedIn(fixture)
        
        await fixture.vm.deleteAccount(viewController: vc)
        
        #expect(fixture.authService.isSignedIn == false)
    }
    
    @Test func `Google user displays providers then deletes`() async throws {
        let usedProviders: [AuthProvider] = [.google, .email]
        let fixture = Fixture(providers: usedProviders)
        await fixture.signIn()
        assertUserSignedIn(fixture)
        
        let deletionTask = Task {
            await fixture.vm.deleteAccount(viewController: vc)
        }
        await waitUntil { fixture.vm.availableProviders != nil }
        
        #expect(fixture.vm.availableProviders == usedProviders)
        fixture.vm.onProviderPicked(.google)
        await deletionTask.value
        
        #expect(fixture.authService.isSignedIn == false)
    }
    
    @Test func `Email user confirms passwrod then deletes`() async throws {
        let usedProviders: [AuthProvider] = [.email]
        let fixture = Fixture(providers: usedProviders)
        await fixture.signIn()
        assertUserSignedIn(fixture)
        
        let deletionTask = Task {
            await fixture.vm.deleteAccount(viewController: vc)
        }
        await waitUntil { fixture.vm.availableProviders != nil }
        
        #expect(fixture.vm.availableProviders == usedProviders)
        fixture.vm.onProviderPicked(.email)
        await waitUntil { fixture.vm.awaitingPassword }
        
        fixture.vm.onPasswordConfirmed(submit: true)
        await deletionTask.value
        
        #expect(fixture.authService.isSignedIn == false)
    }
    
    @Test func `Canceling providers pickup does nothing`() async throws {
        let usedProviders: [AuthProvider] = [.google, .email]
        let fixture = Fixture(providers: usedProviders)
        await fixture.signIn()
        assertUserSignedIn(fixture)
        
        let deletionTask = Task {
            await fixture.vm.deleteAccount(viewController: vc)
        }
        await waitUntil { fixture.vm.availableProviders != nil }
        
        #expect(fixture.vm.availableProviders == usedProviders)
        fixture.vm.onProviderPicked(nil)
        await deletionTask.value
        
        #expect(fixture.authService.isSignedIn)
    }
    
    @Test func `Canceling password confirmation does nothing`() async throws {
        let usedProviders: [AuthProvider] = [.email]
        let fixture = Fixture(providers: usedProviders)
        await fixture.signIn()
        assertUserSignedIn(fixture)
        
        let deletionTask = Task {
            await fixture.vm.deleteAccount(viewController: vc)
        }
        await waitUntil { fixture.vm.availableProviders != nil }
        
        #expect(fixture.vm.availableProviders == usedProviders)
        fixture.vm.onProviderPicked(.email)
        await waitUntil { fixture.vm.awaitingPassword }
        
        fixture.vm.onPasswordConfirmed(submit: false)
        await deletionTask.value
        
        #expect(fixture.authService.isSignedIn)
    }
    
    private func assertUserSignedIn(_ fixture: Fixture) {
        #expect(fixture.authService.isSignedIn)
        #expect(fixture.deviceTokens.token != nil)
    }
}

private class StubAuthService: AuthService {
    let resendIntervalSec: Double = 60
    
    private(set) var isSignedIn: Bool
    private let providers: [PharmaScout.AuthProvider]
    
    init(isSignedIn: Bool = true, providers: [PharmaScout.AuthProvider] = [.apple]) {
        self.isSignedIn = isSignedIn
        self.providers = providers
    }
    
    func signUp(email: String, password: String, fullName: String, redirectTo url: URL?) async throws {
        isSignedIn = true
    }
    
    func signIn(email: String, password: String) async throws {
        isSignedIn = true
    }
    
    func signOut() async throws {
        isSignedIn = false
    }
    
    func authStateStream() async -> AsyncStream<PharmaScout.AuthState> {
        AsyncStream.makeStream().stream
    }
    
    func getProviders() async throws -> [PharmaScout.AuthProvider] {
        providers
    }
    
    func deleteAccount(reauth reauthCredential: PharmaScout.ReauthCredential?) async throws {
        
    }
    
    func clearLocalSession() async throws {
        isSignedIn = false
    }
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {}
    func resetPassword(newPassword: String) async throws {}
    func signInWithCredential(_ credential: PharmaScout.OAuthCredential) async throws {}
    func handle(url: URL, passwordReset: Bool) async throws {}
}

private class StubDeviceTokenService: DeviceTokenService {
    private(set) var token: String?
    
    func register(token: String) async throws {
        self.token = token
    }
    
    func unregister(token: String) async throws {
        self.token = nil
    }
}

private struct StubAppleReauthenticationService: AppleReauthenticationService {
    func authorizationCode(viewController: UIViewController) async throws -> String {
        "Apple code"
    }
}

private struct StubGoogleReauthenticationService: GoogleReauthenticationService {
    func idToken(viewController vc: UIViewController) async throws -> String {
        "Google token"
    }
    
    
}

@MainActor
private struct Fixture {
    let vm: AccountActionsViewModel
    let authService: StubAuthService
    let deviceTokens: StubDeviceTokenService
    let push: PushTokenCoordinator
    
    init(
        authService: StubAuthService? = nil,
        appleReauthenticationService: AppleReauthenticationService? = nil,
        googleReauthenticationService: GoogleReauthenticationService? = nil,
        providers: [AuthProvider] = [.apple]
    ) {
        self.authService = authService ?? StubAuthService(providers: providers)
        self.deviceTokens = StubDeviceTokenService()
        push = PushTokenCoordinator(deviceTokenService: deviceTokens)
        vm = AccountActionsViewModel(
            authService: self.authService,
            pushTokenCoordinator: push,
            appleReauthenticationService: appleReauthenticationService ?? StubAppleReauthenticationService(),
            googleReauthenticationService: googleReauthenticationService ?? StubGoogleReauthenticationService()
        )
    }
    
    func signIn() async {
        await push.observeToken(
            AsyncStream { c in
                c.yield("token")
                c.finish()
            })
        await push.observeAuthState(
            AsyncStream { c in
                c.yield(.authenticated(.init(user: .samples[0], accountState: .patient)))
                c.finish()
            }
        )
    }
}

@MainActor
private func waitUntil(_ condition: () -> Bool) async {
    for _ in 0..<1000 where !condition() { await Task.yield() }
}

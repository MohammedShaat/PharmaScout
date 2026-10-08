//
//  DefaultAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation

struct MockAuthService: AuthService {
    let resendIntervalSec: Double = 10
    let authState: AsyncStream<AuthState> = AsyncStream { continuation in
        continuation.yield(.authenticated)
    }
    let authSession: AuthSession? = {
        let user = AppUser.samples[0]
        
        // {{ Patient }}
//        return AuthSession(user: user, role: .patient, pharmacyStaff: nil)


        // {{ Pending }}
        var pharmacyStaffMember = PharmacyStaffMember.samples[0]
        pharmacyStaffMember.status = .pending
        return AuthSession(user: user, role: .pharmacist, pharmacyStaff: pharmacyStaffMember)
        
        // {{ Rejected }}
//        var pharmacyStaffMember = PharmacyStaffMember.samples[0]
//        pharmacyStaffMember.status = .rejected
//        return AuthSession(user: user, role: .pharmacist, pharmacyStaff: pharmacyStaffMember)
        
//        let pharmacyStaffMember = PharmacyStaffMember.samples[0]
//        return AuthSession(user: user, role: .pharmacist, pharmacyStaff: pharmacyStaffMember)
    }()
    
    func signUp(email: String, password: String, redirectTo url: URL?) async throws {}
    
    func handle(url: URL, passwordReset: Bool) async throws {}
    
    func signIn(email: String, password: String) async throws {}
    
    func signOut() async throws {}
    
    func sendPasswordResetRequest(email: String, redirectTo url: URL?) async throws {}
    
    func resetPassword(newPassword: String) async throws {}
    
    func signInWithCredential(_ credential: OAuthCredential) async throws {}
    
    func getUser() async throws -> AppUser {
        AppUser(id: "1", fullName: "Mohammed Shaat", email: "mohammed@email.com")
    }
    
    func refreshAuthSession() async throws {
        try? await Task.sleep(for: .seconds(2))
    }
}




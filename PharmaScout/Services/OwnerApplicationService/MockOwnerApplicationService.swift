//
//  MockOwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

struct MockOwnerApplicationService: OwnerApplicationService {
    func generateCode() async throws -> InvitaionCode {
        try? await Task.sleep(for: .seconds(2))
        
        return .sample
    }
    
    func applyForPharmacyOwnership(code: String) async throws -> String {
        try? await Task.sleep(for: .seconds(2))
        
        return UUID().uuidString
    }
    
    func getOwnerApplications(_ request: OwnerApplicationsRequest) async throws -> [OwnerApplication] {
        try? await Task.sleep(for: .seconds(2))
        
        let slicedApplications = OwnerApplication.samples
            .dropFirst(request.offset)
            .prefix(request.limit)
        
        return Array(slicedApplications)
    }
    
    func getOwnerApplication(for applicationId: String) async throws -> OwnerApplication {
        try? await Task.sleep(for: .seconds(2))
        
        return .samples.first { $0.id == applicationId }!
    }
    
    func revokeOwnerApplication(for applicationId: String) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func reviewOwnerApplication(_ request: ReviewOwnerApplicationRequest) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
}

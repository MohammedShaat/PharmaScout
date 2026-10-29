//
//  OwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

protocol OwnerApplicationService {
    func generateCode() async throws -> InvitaionCode
    
    func applyForPharmacyOwnership(code: String) async throws -> String
    
    func getOwnerApplications(_ request: OwnerApplicationsRequest) async throws -> [OwnerApplication]
    
    func getOwnerApplication(for applicationId: String) async throws -> OwnerApplication
    
    func revokeOwnerApplication(for applicationId: String) async throws
    
    func reviewOwnerApplication(_ request: ReviewOwnerApplicationRequest) async throws
    
    func subscribeToOwnerApplicationsChanges() async throws -> AsyncStream<Void>
    
    func subscribeToOwnerApplicationChanges(for ownerApplicationId: String) async throws -> AsyncStream<Void>
}

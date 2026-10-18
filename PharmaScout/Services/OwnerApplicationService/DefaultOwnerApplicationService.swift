//
//  DefaultOwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation
import Supabase

struct DefaultOwnerApplicationService: OwnerApplicationService {
    private let supabase = SupabaseManager.shared.client
    
    func generateCode() async throws -> InvitaionCode {
        let createOwnerCodeFunc = SupabaseManager.Database.Functions.createOwnerCode.self
        
        do {
            let invitationCode: InvitaionCode =  try await supabase
                .rpc(createOwnerCodeFunc.name)
                .single()
                .execute()
                .value
            
            return invitationCode
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func applyForPharmacyOwnership(code: String) async throws -> String {
        let applyForPharmacyOwnershipFunc = SupabaseManager.Database.Functions.applyForPharmacyOwnership.self
        let params = applyForPharmacyOwnershipFunc.Params.self
        
        do {
            let applicationId: String =  try await supabase
                .rpc(
                    applyForPharmacyOwnershipFunc.name,
                    params: [params.code: code]
                )
                .single()
                .execute()
                .value
            
            return applicationId
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getOwnerApplications(_ request: OwnerApplicationsRequest) async throws -> [OwnerApplication] {
        let getOwnerApplicationsFunc = SupabaseManager.Database.Functions.getOwnerApplications.self
        
        do {
            let ownerApplications: [OwnerApplication] =  try await supabase
                .rpc(getOwnerApplicationsFunc.name, params: request)
                .execute()
                .value
            
            return ownerApplications
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getOwnerApplication(for applicationId: String) async throws -> OwnerApplication {
        let getOwnerApplicationFunc = SupabaseManager.Database.Functions.getOwnerApplication.self
        let params = getOwnerApplicationFunc.Params.self
        
        do {
            let ownerApplication: OwnerApplication =  try await supabase
                .rpc(
                    getOwnerApplicationFunc.name,
                    params: [params.id: applicationId]
                )
                .single()
                .execute()
                .value
            
            return ownerApplication
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func revokeOwnerApplication(for applicationId: String) async throws {
        let revokeOwnerApplicationFunc = SupabaseManager.Database.Functions.revokeOwnerApplication.self
        let params = revokeOwnerApplicationFunc.Params.self
        
        do {
            try await supabase
                .rpc(
                    revokeOwnerApplicationFunc.name,
                    params: [params.applicationId: applicationId]
                )
                .single()
                .execute()
                .value
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func reviewOwnerApplication(_ request: ReviewOwnerApplicationRequest) async throws {
        let reviewOwnerApplicationFunc = SupabaseManager.Database.Functions.reviewOwnerApplication.self
        
        do {
            try await supabase
                .rpc(reviewOwnerApplicationFunc.name, params: request)
                .single()
                .execute()
                .value
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

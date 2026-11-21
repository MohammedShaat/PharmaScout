//
//  DefaultOwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation
import Supabase

class DefaultOwnerApplicationService: OwnerApplicationService {
    private let supabase = SupabaseManager.shared.client
    private var realtimeHubs: [String: SupabaseManager.SupabaseRealtimeHub] = [:]
    
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
    
    func subscribeToOwnerApplicationsChanges() async throws -> AsyncStream<Void> {
        let ownerApplicationTable = SupabaseManager.Database.Table.ownerApplication.self
        let hub = realtimeHub(
            for: ownerApplicationTable.name,
            tableName: ownerApplicationTable.name,
        )
        return try await hub.subscribeToChanges()
    }
    
    func subscribeToOwnerApplicationChanges(for ownerApplicationId: String) async throws -> AsyncStream<Void> {
        let ownerApplicationTable = SupabaseManager.Database.Table.ownerApplication.self
        let columns = ownerApplicationTable.Column.self
        let hub = realtimeHub(
            for: "\(ownerApplicationTable.name)-\(ownerApplicationId)",
            tableName: ownerApplicationTable.name,
            filter: .eq(columns.id, value: ownerApplicationId)
        )
        return try await hub.subscribeToChanges()
    }

    private func realtimeHub(for id: String, tableName: String, filter: RealtimePostgresFilter? = nil) -> SupabaseManager.SupabaseRealtimeHub {
        if let existing = realtimeHubs[id] { return existing }
        
        let hub = SupabaseManager.SupabaseRealtimeHub(
            channelName: "\(tableName)-\(id)",
            tableName: tableName,
            filter: filter,
            onIdle: { [weak self] idleHub in
                if self?.realtimeHubs[id] === idleHub {
                    self?.realtimeHubs[id] = nil
                }
            }
        )
        realtimeHubs[id] = hub
        return hub
    }
}

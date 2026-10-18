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
}

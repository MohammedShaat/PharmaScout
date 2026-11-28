//
//  DefaultDeviceTokenService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/13/26.
//

import Foundation
import Supabase

struct DefaultDeviceTokenService: DeviceTokenService {
    private let supabase = SupabaseManager.shared.client
    
    func register(token: String) async throws {
        let registerDeviceTokenFunc = SupabaseManager.Database.Functions.registerDeviceToken.self
        let params = registerDeviceTokenFunc.Params.self
        
        do {
            try await supabase
                .rpc(
                    registerDeviceTokenFunc.name,
                    params: [
                        params.token: token,
                        params.platform: "ios"
                    ]
                )
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func unregister(token: String) async throws {
        let deviceTokensTable = SupabaseManager.Database.Table.deviceTokens.self
        let columns = deviceTokensTable.Column.self
        
        do {
            try await supabase
                .from(deviceTokensTable.name)
                .delete()
                .equals(columns.token, value: token)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
}

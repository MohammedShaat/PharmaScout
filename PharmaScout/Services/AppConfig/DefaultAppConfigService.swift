//
//  DefaultAppConfigService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation
import Supabase

struct DefaultAppConfigService: AppConfigService {
    private let supabase = SupabaseManager.shared.client
    
    private let appConfigTable = SupabaseManager.Database.Table.appConfig.self
    
    private var columns: SupabaseManager.Database.Table.appConfig.Column.Type {
        appConfigTable.Column.self
    }
    private var keys: SupabaseManager.Database.Table.appConfig.Key.Type {
        appConfigTable.Key.self
    }
    
    func getMaxSearchRadiusMeters() async throws -> Double {
        do {
            let maxMetersStr: ConfigValue = try await supabase
                .from(appConfigTable.name)
                .select()
                .eq(columns.key, value: keys.maxSearchRadiusMeters)
                .single()
                .execute()
                .value
            
            return Double(maxMetersStr.value) ?? 0
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }    
}

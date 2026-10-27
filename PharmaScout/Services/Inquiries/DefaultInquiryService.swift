//
//  DefaultInquiryService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation
import Supabase

class DefaultInquiryService: InquiryService {
    private let supabase = SupabaseManager.shared.client
    
    private var realtimeHubs: [String: SupabaseManager.SupabaseRealtimeHub] = [:]
    
    func getInquiries(_ params: GetInquiriesParams) async throws -> [Inquiry] {
        let getPharmacyInquiriesFunc = SupabaseManager.Database.Functions.getPharmacyInquiries.self
        
        do {
            let inquiries: [Inquiry] = try await supabase
                .rpc(getPharmacyInquiriesFunc.name, params: params)
                .execute()
                .value
            
            return inquiries
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getInquiry(forId inquiryId: String) async throws -> Inquiry {
        let getPharmacyInquiryFunc = SupabaseManager.Database.Functions.getPharmacyInquiry.self
        let params = getPharmacyInquiryFunc.Params.self
        
        do {
            let inquiry: Inquiry = try await supabase
                .rpc(
                    getPharmacyInquiryFunc.name,
                    params: [params.inquiryId: inquiryId]
                )
                .execute()
                .value
            
            return inquiry
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func respondToInquiry(_ params: RespondToInquiryParams) async throws {
        let respondToInquiryFunc = SupabaseManager.Database.Functions.respondToPharmacyInquiry.self
        
        do {
            try await supabase
                .rpc(respondToInquiryFunc.name, params: params)
                .execute()
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func getNumberOfAllTodaysInquiries(for pharmacyId: String) async throws -> Int {
        try await getNumberOfTodaysInquiries(for: pharmacyId)
    }
     
    func getNumberOfAnsweredTodaysInquiries(for pharmacyId: String) async throws -> Int {
        try await getNumberOfTodaysInquiries(for: pharmacyId, onlyAnswered: true)
    }
    
    private func getNumberOfTodaysInquiries(for pharmacyId: String, onlyAnswered: Bool = false) async throws -> Int {
        let inquiryTable = SupabaseManager.Database.Table.PharmacyInquiry.self
        let columns = inquiryTable.Column.self
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: .now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? .now.addingTimeInterval(1000)

        do {
            var query = supabase
                .from(inquiryTable.name)
                .select(head: true, count: .exact)
                .equals(columns.pharmacyId, value: pharmacyId)
                .gte(columns.createdAt, value: startOfDay)
                .lt(columns.createdAt, value: startOfTomorrow)
            
            if onlyAnswered {
                query = query
                    .equals(columns.status, value: InquiryStatus.answered.rawValue)
            }
            
            let count = try await query
                .execute()
                .count
            
            return count ?? 0
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func canEditInquiry(forId inquiryId: String) async throws -> Bool {
        let canEditPharmacyInquiryFunc = SupabaseManager.Database.Functions.canEditPharmacyInquiry.self
        let params = canEditPharmacyInquiryFunc.Params.self
        
        do {
            let canEdit: Bool = try await supabase
                .rpc(
                    canEditPharmacyInquiryFunc.name,
                    params: [params.inquiryId: inquiryId]
                )
                .execute()
                .value
            
            return canEdit
            
        } catch {
            throw SupabaseErrorMapper.mapDatabseError(error)
        }
    }
    
    func subscribeToPharmacyInquiriesChanges(pharmacyId: String) async throws -> AsyncStream<Void> {
        let inquiryTable = SupabaseManager.Database.Table.PharmacyInquiry.self
        let columns = inquiryTable.Column.self
        let hub = realtimeHub(
            for: "\(inquiryTable.name)-\(pharmacyId)",
            tableName: inquiryTable.name,
            filter: .eq(columns.pharmacyId, value: pharmacyId)
        )
        return try await hub.subscribeToChanges()
    }
    
    
    func subscribeToInquiryChanges(inquiryId: String) async throws -> AsyncStream<Void> {
        let inquiryTable = SupabaseManager.Database.Table.PharmacyInquiry.self
        let columns = inquiryTable.Column.self
        let hub = realtimeHub(
            for: "\(inquiryTable.name)-\(inquiryId)",
            tableName: inquiryTable.name,
            filter: .eq(columns.id, value: inquiryId)
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

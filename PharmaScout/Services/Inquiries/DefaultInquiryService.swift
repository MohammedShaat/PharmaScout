//
//  DefaultInquiryService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation
import Supabase

struct DefaultInquiryService: InquiryService {
    private let supabase = SupabaseManager.shared.client
    
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
        let inquiryTable = SupabaseManager.Database.Table.pharmacyInquiry.self
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
}

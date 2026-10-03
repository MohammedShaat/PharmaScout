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
}

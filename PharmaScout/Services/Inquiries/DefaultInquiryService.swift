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
}

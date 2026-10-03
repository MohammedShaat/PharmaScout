//
//  MockInquiryService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

struct MockInquiryService: InquiryService {
    func getInquiries(_ params: GetInquiriesParams) async throws -> [Inquiry] {
        try? await Task.sleep(for: .seconds(2))
        
        let filteredInquiries = Inquiry.samples
            .filter { $0.pharmacyId == params.pharmacyId }
            .dropFirst(params.offset)
            .prefix(params.limit)
        
        return Array(filteredInquiries)
    }
}

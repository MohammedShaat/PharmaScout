//
//  InquiryService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

protocol InquiryService {
    func getInquiries(_ params: GetInquiriesParams) async throws -> [Inquiry]
    
    func getInquiry(forId inquiryId: String) async throws -> Inquiry
    
    func respondToInquiry(_ params: RespondToInquiryParams) async throws
}

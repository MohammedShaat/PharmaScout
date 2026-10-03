//
//  InquiryService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import Foundation

protocol InquiryService {
    func getInquiries(_ params: GetInquiriesParams) async throws -> [Inquiry]
}

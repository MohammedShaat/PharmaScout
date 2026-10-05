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
            .filter { inquiry in
                inquiry.pharmacyId == params.pharmacyId
                && (params.filter == .all || inquiry.status.rawValue == params.filter.rawValue)
            }
            .dropFirst(params.offset)
            .prefix(params.limit)
        
        return Array(filteredInquiries)
    }
    
    func getInquiry(forId inquiryId: String) async throws -> Inquiry {
        try? await Task.sleep(for: .seconds(2))
        
        return Inquiry.samples.first { $0.id == inquiryId }!
    }
    
    func respondToInquiry(_ params: RespondToInquiryParams) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func getNumberOfAllTodaysInquiries(for pharmacyId: String) async throws -> Int {
        try await getNumberOfTodaysInquiries(for: pharmacyId)
    }
     
    func getNumberOfAnsweredTodaysInquiries(for pharmacyId: String) async throws -> Int {
        try await getNumberOfTodaysInquiries(for: pharmacyId, onlyAnswered: true)
    }
    
    private func getNumberOfTodaysInquiries(for pharmacyId: String, onlyAnswered: Bool = false) async throws -> Int {
        try? await Task.sleep(for: .seconds(2))
        
        let startOfDay = Calendar.current.startOfDay(for: .now)
        
        return Inquiry.samples.filter {
            $0.createdAt <= startOfDay
            && $0.createdAt < Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? .now
            && !(onlyAnswered && $0.status != .answered)
        }
        .count
    }
}

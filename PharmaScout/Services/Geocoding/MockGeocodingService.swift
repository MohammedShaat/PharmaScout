//
//  MockGeocodingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

struct MockGeocodingService: GeocodingService {
    func reverseGeocode(_ coordiante: Coordinate) async throws -> ResolvedPlace {
        try? await Task.sleep(for: .seconds(2))
        
        return ResolvedPlace(suggestedAddress: "Al Rasheed Street, Gaza", timeZone: TimeZone.current)
    }
}

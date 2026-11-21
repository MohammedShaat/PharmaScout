//
//  GeocodingService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/20/26.
//

import Foundation

protocol GeocodingService {
    func reverseGeocode(_ coordiante: Coordinate) async throws -> ResolvedPlace
}

//
//  DirectionsService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation

protocol DirectionsService {
    func calculateRoute(from source: Coordinate, to destination: Coordinate) async throws -> MapRoute
}

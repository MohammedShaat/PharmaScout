//
//  MockDirectionsSrevice.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation

struct MockDirectionsSrevice: DirectionsService {
    func calculateRoute(from source: Coordinate, to destination: Coordinate) async throws -> MapRoute {
        try? await Task.sleep(for: .seconds(2))
        
        return try await DefaultDirectionsService().calculateRoute(from: source, to: destination)
    }
}

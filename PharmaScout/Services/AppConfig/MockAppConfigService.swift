//
//  MockAppConfigService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation

struct MockAppConfigService: AppConfigService {
    func getMaxSearchRadiusMeters() async throws -> Double {
        try? await Task.sleep(for: .seconds(2))
        
        return 100_000
    }
}

//
//  MockDeviceTokenService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/13/26.
//

import Foundation

struct MockDeviceTokenService: DeviceTokenService {
    func register(token: String) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
    
    func unregister(token: String) async throws {
        try? await Task.sleep(for: .seconds(2))
    }
}

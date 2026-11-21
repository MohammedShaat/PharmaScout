//
//  AppConfigService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import Foundation

protocol AppConfigService {
    func getMaxSearchRadiusMeters() async throws -> Double
}

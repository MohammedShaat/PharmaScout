//
//  DeviceTokenService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/13/26.
//

import Foundation

protocol DeviceTokenService {
    func register(token: String) async throws
    
    func unregister(token: String) async throws
}

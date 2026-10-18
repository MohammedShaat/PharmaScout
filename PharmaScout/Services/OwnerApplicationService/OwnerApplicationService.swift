//
//  OwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

protocol OwnerApplicationService {
    func generateCode() async throws -> InvitaionCode
}

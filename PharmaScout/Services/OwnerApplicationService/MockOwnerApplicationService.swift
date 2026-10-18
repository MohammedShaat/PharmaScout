//
//  MockOwnerApplicationService.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

struct MockOwnerApplicationService: OwnerApplicationService {
    func generateCode() async throws -> InvitaionCode {
        try? await Task.sleep(for: .seconds(2))
        
        return .sample
    }
}

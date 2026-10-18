//
//  OwnerInvitationViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

@Observable
class OwnerInvitationViewModel {
    private let ownerApplicationService: OwnerApplicationService
    
    private(set) var invitationCode: InvitaionCode?
    private(set) var codeLoadingState = LoadingState()
    
    init(ownerApplicationService: OwnerApplicationService) {
        self.ownerApplicationService = ownerApplicationService
    }
    
    func generateCode() async {
        codeLoadingState.startLoading()
        defer { codeLoadingState.stopLoading() }
        
        do {
            invitationCode = try await ownerApplicationService.generateCode()
            
        } catch {
            codeLoadingState.fail(error)
            print("Failed to generate owner invitation code\n", error)
        }
    }
}

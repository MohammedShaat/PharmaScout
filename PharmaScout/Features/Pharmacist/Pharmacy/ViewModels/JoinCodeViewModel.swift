//
//  JoinCodeViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import Foundation

@Observable
class JoinCodeViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacyId: String
    
    private(set) var joinCode: InvitaionCode?
    
    private(set) var loadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService, pharmacyId: String) {
        self.pharmacyService = pharmacyService
        self.pharmacyId = pharmacyId
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func getOrGenerateCodeIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            await getOrGenerateCode()
        }
    }
    
    func regenerateCode() async {
        await generateCode()
    }
    
    private func getOrGenerateCode() async {
        await getActiveCode()
        if joinCode == nil {
            await generateCode()
        }
    }
    
    private func getActiveCode() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            joinCode = try await pharmacyService.getActiveJoinCode(for: pharmacyId)
            
        } catch {
            loadingState.fail(error)
            print("Failed to get active pharmacy join code\n", error)
        }
    }
    
    private func generateCode() async {
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            joinCode = try await pharmacyService.generateJoinCode(for: pharmacyId)
            
        } catch {
            loadingState.fail(error)
            print("Failed to generate pharmacy join code\n", error)
        }
    }
}

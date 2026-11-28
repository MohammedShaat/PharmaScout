//
//  JoinCodeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import SwiftUI

struct JoinCodeScreen: View {
    @State private var vm: JoinCodeViewModel
    @State private var generateCodeTask: Task<Void, Never>?
    
    init(pharmacyService: PharmacyService, pharmacyId: String) {
        let viewModel = JoinCodeViewModel(
            pharmacyService: pharmacyService,
            pharmacyId: pharmacyId
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CodeGenerationView(
            title: "Your join code",
            subtitle: "share this \(vm.codeLength)-character code with staff members who want to join your pharmacy.",
            systemName: "person.badge.plus",
            invitationCode: vm.joinCode,
            codeLength: vm.codeLength,
            loadingState: vm.loadingState,
            shareLinkSubject: "Pharmacy Join Code",
            shareLinkMessage: "Use this code to join our pharmacy.",
            leakMessage: "Regenerate it and the old one stops working.",
            onGenerateTapped: generateCode,
            onRegenerateTapped: generateCode
        )
        .padding(DesignSystem.Spacing.xLarge)
        .customNavTitle("Invite a pharmacist")
        .onAppear {
            vm.getOrGenerateCodeIfNeeded()
        }
        .onDisappear {
            generateCodeTask?.cancel()
        }
    }
    
    private func generateCode() {
        generateCodeTask?.cancel()
        generateCodeTask = Task {
            await vm.regenerateCode()
        }
    }
}

#Preview {
    CustomNavStack {
        JoinCodeScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacyId: Pharmacy.samples[0].id
        )
    }
}

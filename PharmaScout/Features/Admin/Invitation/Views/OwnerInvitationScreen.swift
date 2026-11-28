//
//  OwnerInvitationScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct OwnerInvitationScreen: View {
    @State private var vm: OwnerInvitationViewModel
    @State private var task: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService) {
        let viewModel = OwnerInvitationViewModel(ownerApplicationService: ownerApplicationService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            CodeGenerationView(
                title: "Pharmacy owner code",
                subtitle: "Share this \(vm.codeLength)-character code with a pharmacy owner so they can submit their pharmacy application.",
                systemName: "building.2.crop.circle",
                invitationCode: vm.invitationCode,
                codeLength: vm.codeLength,
                loadingState: vm.codeLoadingState,
                shareLinkSubject: "PharmaScout Pharmacy Owner Code",
                shareLinkMessage: "Use this code to apply as a pharmacy owner on PharmaScout.",
                leakMessage: "Revoke it from its details screen.",
                onGenerateTapped: generateCode,
                onRegenerateTapped: generateCode
            )
            .customNavBarVisibility(.root)
            .customNavTitle("Invite owner")
            .padding(DesignSystem.Spacing.xLarge)
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    private func generateCode() {
        task?.cancel()
        task = Task {
            await vm.generateCode()
        }
    }
}

#Preview {
    OwnerInvitationScreen(ownerApplicationService: MockOwnerApplicationService.sample)
}

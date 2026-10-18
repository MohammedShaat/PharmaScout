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
            VStack {
                
                LoadingContentView(
                    LoadingState: vm.codeLoadingState,
                    isEmpty: vm.invitationCode == nil,
                    emptyMessage: "") {
                        if let invitationCode = vm.invitationCode {
                            InvitationCodeView(
                                title: "Share this 6-character code with the person applying to become a pharmacy owner.",
                                invitationCode: invitationCode,
                                shareLinkSubject: "Pharmacy Owner Invitation Code",
                                shareLinkMessage: "Use this code to apply to become a pharmacy owner on PharmaScout."
                            )
                        }
                    }
                
                PrimaryButtonView(
                    title: "Generate code",
                    isDisabled: vm.codeLoadingState.status != .idle
                ) {
                    task?.cancel()
                    task = Task {
                        await vm.generateCode()
                    }
                }
            }
            .customBackButtonVisibility(false)
            .padding(DesignSystem.Spacing.xLarge)
            .onDisappear {
                task?.cancel()
            }
        }
    }
}

#Preview {
    OwnerInvitationScreen(ownerApplicationService: MockOwnerApplicationService.sample)
}

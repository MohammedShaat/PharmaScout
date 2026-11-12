//
//  JoinPharmacyScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/8/26.
//

import SwiftUI

struct JoinPharmacyScreen: View {
    @State private var vm: JoinPharmacyViewModel
    @State private var sendTask: Task<Void, Never>?
    
    init(authService: AuthService, pharmacyService: PharmacyService) {
        let viewModel = JoinPharmacyViewModel(
            authService: authService,
            pharmacyService: pharmacyService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if vm.codeSentSuccessfully {
                CodeRequestSuccessView(
                    subtitle: "The pharmacy owner will review your request. We’ll take you to your request status.",
                    copyableTitle: "Your membership ID",
                    copyableValue: vm.staffMemeberId
                )
                
            } else {
                CodeEntryView(
                    title: "Ownership codes are issued personally. Ask the PharmaScout team for yours.",
                    subtitle: "Ask the pharmacy owner for their join code. They can find it in their Profile.",
                    code: $vm.code,
                    codeLength: vm.codeLength,
                    loadingState: vm.requestLoadingState,
                    canSend: vm.canSend,
                    onSendTapped:  {
                        sendTask?.cancel()
                        sendTask = Task {
                            await vm.sendRequest()
                        }
                    }
                )
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .customNavTitle("Join a pharmacy")
        .onDisappear {
            sendTask?.cancel()
        }
    }
}

#Preview {
    CustomNavStack {
        JoinPharmacyScreen(
            authService: MockAuthService.sample,
            pharmacyService: MockPharmacyService.sample
        )
    }
}

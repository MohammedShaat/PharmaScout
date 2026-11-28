//
//  BecomePharmacyOwnerScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct BecomePharmacyOwnerScreen: View {
    @State private var vm: BecomePharmacyOwnerViewModel
    @State private var task: Task<Void, Never>?
    
    init(ownerApplicationService: OwnerApplicationService) {
        let viewModel = BecomePharmacyOwnerViewModel(ownerApplicationService: ownerApplicationService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if vm.codeSentSuccessfully {
                CodeRequestSuccessView(
                    subtitle: "Your application is under review. We’ll take you to your application status.",
                    copyableTitle: "Application ID",
                    copyableValue: vm.applicationId
                )
                
            } else {
                CodeEntryView(
                    title: "Enter the code to apply for pharmacy ownership",
                    subtitle: "Ownership codes are issued personally. Ask the PharmaScout team for yours.",
                    code: $vm.code,
                    codeLength: vm.codeLength,
                    loadingState: vm.requestLoadingState,
                    canSend: vm.canSend,
                    onSendTapped:  {
                        task?.cancel()
                        task = Task {
                            await vm.sendRequest()
                        }
                    }
                )
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .customNavTitle("Become a pharmacy owner")
        .onDisappear {
            task?.cancel()
        }
    }
}

#Preview {
    CustomNavStack {
        BecomePharmacyOwnerScreen(ownerApplicationService: MockOwnerApplicationService.sample)
    }
}

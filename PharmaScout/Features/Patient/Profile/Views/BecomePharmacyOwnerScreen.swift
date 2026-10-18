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
        VStack {
            if vm.codeSentSuccessfully {
                successSection
                
            } else {
                instructionAndInputSection
                
                errorSection
                
                sendButtonSection
            }
        }
        .padding(DesignSystem.Spacing.xLarge)
        .onDisappear {
            task?.cancel()
        }
    }
    
    private var successSection: some View {
        VStack {
            Text("Request has been sent successfully")
                .font(.title)
                .foregroundStyle(.theme.textPrimary)
                .multilineTextAlignment(.center)
            
            if let applicationId = vm.applicationId {
                Text("Your application ID: \(applicationId)")
            }
        }
    }
    
    private var instructionAndInputSection: some View {
        InvitationCodeEntryView(
            title: "Enter the code to apply for pharmacy ownership",
            code: $vm.code,
            codeLength: vm.codeLength
        )
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = vm.requestLoadingState.error {
            Text(error.errorDescription)
                .padding(.vertical, DesignSystem.Spacing.large)
        }
    }
    
    private var sendButtonSection: some View  {
        PrimaryButtonView(
            title: "Send",
            isDisabled: !vm.canSend,
            isLoading: vm.requestLoadingState.status != .idle) {
                task?.cancel()
                task = Task {
                    await vm.sendRequest()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.large)
    }
}

#Preview {
    BecomePharmacyOwnerScreen(ownerApplicationService: MockOwnerApplicationService.sample)
}

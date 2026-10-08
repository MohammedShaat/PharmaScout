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
        ScrollView {
            VStack(spacing: 0) {
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
                sendTask?.cancel()
            }
        }
        .refreshable(action: vm.refresh)
    }
    
    private var successSection: some View {
        VStack {
            Text("Request has been sent successfully")
                .font(.title)
                .foregroundStyle(.theme.textPrimary)
                .multilineTextAlignment(.center)
            
            if let pharmacyId = vm.pharmacyId {
                Text("Pharmacy ID: \(pharmacyId)")
            }
        }
    }
    
    private var instructionAndInputSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text("Enter the code to send membership request")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("The code must be 6 characters long.")
            }
            
            TextFieldView(title: $vm.code, placeholder: "Enter the code here")
                .frame(maxWidth: 200)
        }
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
                sendTask?.cancel()
                sendTask = Task {
                    await vm.sendRequest()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.large)
    }
}

#Preview {
    JoinPharmacyScreen(
        authService: MockAuthService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}

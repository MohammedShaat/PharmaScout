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
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy) {
        let viewModel = JoinCodeViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            detailSection
            
            Spacer()
            
            regenerateSection
            
            Spacer()
        }
        .onAppear {
            vm.getOrGenerateCodeIfNeeded()
        }
        .onDisappear {
            generateCodeTask?.cancel()
        }
    }
    
    private var detailSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            isEmpty: vm.joinCode == nil,
            emptyMessage: "") {
                if let joinCode = vm.joinCode {
                    InvitationCodeView(
                        title: "Share this 6-character code with staff members who want to join your pharmacy.",
                        invitationCode: joinCode,
                        shareLinkSubject: "Pharmacy Join Code",
                        shareLinkMessage: "Use this code to join our pharmacy."
                    )
                }
            }
    }
    
    private var regenerateSection: some View {
        Text("Regenerate Code")
            .foregroundStyle(.theme.textPrimary)
            .clickable(isDisabled: vm.loadingState.status != .idle) {
                generateCodeTask?.cancel()
                generateCodeTask = Task {
                    await vm.regenerateCode()
                }
            }
    }
}

#Preview {
    JoinCodeScreen(
        pharmacyService: MockPharmacyService.sample,
        pharmacy: .samples[0]
    )
}

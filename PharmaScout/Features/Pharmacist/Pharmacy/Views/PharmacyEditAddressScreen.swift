//
//  EditAddressScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct PharmacyEditAddressScreen: View {
    @State private var vm: PharmacyEditAddressViewModel
    @State private var updateTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy) {
        let viewModel = PharmacyEditAddressViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            LabeledTextFieldView(title: $vm.name, label: "Pharmacy name", placeholder: "Type your pharmacy's name")
            
            LabeledTextFieldView(title: $vm.address, label: "Address", placeholder: "Type your pharmacy's address")
            
            if let error = vm.loadingState.error {
                Text(error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Save",
                isDisabled: !vm.canUpdate,
                isLoading: vm.loadingState.status != .idle) {
                    updateTask?.cancel()
                    updateTask = Task {
                        await vm.updatePharmacy {
                            dismiss()
                        }
                    }
                }
            
            Spacer()
        }
        .padding(DesignSystem.Spacing.xLarge)
        .onDisappear {
            updateTask?.cancel()
        }
    }
}

#Preview {
    CustomNavStack {
        PharmacyEditAddressScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacy: .samples[0]
        )
    }
}

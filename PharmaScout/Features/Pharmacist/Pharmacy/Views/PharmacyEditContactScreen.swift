//
//  PharmacyEditContactScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI
import Swipy

struct PharmacyEditContactScreen: View {
    @State private var vm: PharmacyEditContactViewModel
    @State private var updateTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy, contacts: [PharmacyContact]) {
        let viewModel = PharmacyEditContactViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy,
            contacts: contacts
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            contactListSection
            
            addNewContactSection
            
            if let error = vm.loadingState.error {
                Text(error.errorDescription)
            }
            
            buttonSection
        }
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .onDisappear {
            updateTask?.cancel()
        }
    }
    
    private var contactListSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            ForEach($vm.contacts) { $contact in
                SwipyView(
                    isSwipingAnItem: $isSwipingAnItem) {
                        contactItemView($contact)
                    } onDeleteTapped: {
                        vm.deleteContact(contact)
                    }
            }
        }
    }
    
    private var addNewContactSection: some View {
        ActionPromptView(actionTitle: "Add new Contact", action: vm.addContact)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func contactItemView(_ contact: Binding<PharmacyContact>) -> some View {
        ContactView(contact: contact)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonSection: some View {
        PrimaryButtonView(
            title: "Save",
            isDisabled: !vm.canUpdate,
            isLoading: vm.loadingState.status != .idle) {
                updateTask?.cancel()
                updateTask = Task {
                    await vm.updateContacts {
                        dismiss()
                    }
                }
            }
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let contacts = PharmacyContact.samples.filter { $0.pharmacyId == pharmacy.id }
    
    PharmacyEditContactScreen(
        pharmacyService: MockPharmacyService.sample,
        pharmacy: pharmacy,
        contacts: contacts
    )
}

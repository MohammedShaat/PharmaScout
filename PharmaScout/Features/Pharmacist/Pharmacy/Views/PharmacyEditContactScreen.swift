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
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                SwipeHintView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                contactListSection
                
                addNewContactSection
            }

            if let error = vm.loadingState.error {
                ErrorView(title: "Couldn't update contacts", description: error.errorDescription)
            }
            
            saveButton
        }
        .customNavTitle("Contact")
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .onDisappear {
            updateTask?.cancel()
        }
    }
    
    private var contactListSection: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            ForEach($vm.contacts) { $contact in
                SwipyView(
                    isSwipingAnItem: $isSwipingAnItem) {
                        ContactEditView(contact: $contact)
                            .padding(DesignSystem.Spacing.large)
                            .roundedBackground()
                    } onDeleteTapped: {
                        vm.deleteContact(contact)
                    }
            }
        }
    }
    
    private var addNewContactSection: some View {
        SecondaryButtonView(title: "Add contact", systemName: "plus", action: vm.addContact)
            .padding(DesignSystem.Spacing.large)
    }
    
    private var saveButton: some View {
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
    
    CustomNavStack {
        PharmacyEditContactScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacy: pharmacy,
            contacts: contacts
        )
    }
}

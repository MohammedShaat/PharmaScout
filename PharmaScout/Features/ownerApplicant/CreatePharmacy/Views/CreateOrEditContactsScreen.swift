//
//  CreateOrEditContactsScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import SwiftUI
import Swipy

struct CreateOrEditContactsScreen: View {
    private let onSaveTapped: (([PharmacyContact]) -> Void)?
   
    @State private var vm: CreateOrEditContactsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(contacts: [PharmacyContact], onSaveTapped: (([PharmacyContact]) -> Void)? = nil) {
        self.onSaveTapped = onSaveTapped
        
        let viewModel = CreateOrEditContactsViewModel(contacts: contacts)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                VStack {
                    if vm.contacts.isNotEmpty {
                        SwipeHintView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        contactListSection
                        
                        addNewContactSection
                    } else {
                        startSection
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }

            DividerView()

            if let error = vm.loadingState.error {
                ErrorView(title: "Couldn't update contacts", description: error.errorDescription)
            }
            
            saveButton
        }
        .customNavTitle("Contact")
        .scrollDisabled(isSwipingAnItem)
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
    
    private var startSection: some View {
        CreatePharmacyEmptyListView(
            systemName: "phone",
            title: "No contact info yet",
            subtitle: "Add a phone number, email, or website so patients can reach you.",
            buttonTitle: "Add contact",
            onButtonTapped: { vm.addContact() }
        )
    }
    
    private var saveButton: some View {
        PrimaryButtonView(
            title: "Save",
            isDisabled: !vm.canUpdate,
            isLoading: vm.loadingState.status != .idle
        ) {
            vm.updateContacts {
                onSaveTapped?(vm.contacts)
                dismiss()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.top, DesignSystem.Spacing.small)
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let contacts = PharmacyContact.samples.filter { $0.pharmacyId == pharmacy.id }
    
    CustomNavStack {
        CreateOrEditContactsScreen(contacts: contacts)
    }
}

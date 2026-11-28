//
//  ContactView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct ContactEditView: View {
    @Binding var contact: PharmacyContact
    
    private var titlePlaceholder: String {
        switch contact.type {
        case .number: "e.g. Reception"
        case .link: "e.g. Website, Instagram, ..."
        case .email: "e.g. Email support"
        }
    }
    
    private var valuePlaceholder: String {
        switch contact.type {
        case .number: "e.g. +970594587265"
        case .link: "e.g. http://www.pharmacy.com"
        case .email: "e.g. pharmacy@mail.com"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            HStack {
                Text("Contact")
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Spacer()
                typePicker
            }
            
            LabeledTextFieldView(title: $contact.title, label: "Title", placeholder: titlePlaceholder)
            
            LabeledTextFieldView(title: $contact.value, label: contact.type.title, placeholder: valuePlaceholder)
        }
    }
    
    private var typePicker: some View {
        Menu {
            Picker("Type", selection: $contact.type) {
                ForEach(ContactType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
        } label: {
            HStack(spacing: DesignSystem.Spacing.small) {
                Label {
                    Text(contact.type.title)
                } icon: {
                    contact.type.icon
                }
                
                Image(systemName: "chevron.down")
                    .fontWeight(.regular)
                    .font(.callout)
            }
            .fontWeight(.bold)
            .foregroundStyle(.theme.green)
            .padding(DesignSystem.Spacing.medium)
            .roundedBackground(background: .theme.greenBackground)
        }
    }
}

#Preview {
    @State @Previewable var contact = PharmacyContact.samples[0]
    @State @Previewable var contact2 = PharmacyContact(id: "", pharmacyId: "", title: "", type: .number, value: "")

    ZStack {
        Color.theme.background.ignoresSafeArea()

        VStack(spacing: 30) {
            Group {
                ContactEditView(contact: $contact)
                
                ContactEditView(contact: $contact2)
            }
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
            .padding()
        }
    }
}


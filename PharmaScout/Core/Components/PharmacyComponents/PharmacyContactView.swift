//
//  PharmacyContactView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyContactView: View {
    let contacts: [PharmacyContact]
    let loadingState: LoadingState
    
    var body: some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: contacts.isEmpty,
            emptyMessage: "There is no contact info"
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                ForEach(contacts) { contact in
                    HStack {
                        Text("\(contact.title) : ")
                        Text(contact.value)
                    }
                    .background(.gray.opacity(0.2))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PharmacyContactView(
        contacts: PharmacyContact.samples,
        loadingState: LoadingState()
    )
}

//
//  PharmacyContactView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyContactListView: View {
    let contacts: [PharmacyContact]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            ForEach(contacts) { contact in
                HStack {
                    Text("\(contact.title) : ")
                    Text(contact.value)
                }
                .background(.gray.opacity(0.2))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        PharmacyContactListView(contacts: PharmacyContact.samples)
    }
}

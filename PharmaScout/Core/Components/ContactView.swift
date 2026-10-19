//
//  ContactView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct ContactView: View {
    @Binding var contact: PharmacyContact
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Contact")
                
                Picker("Type", selection: $contact.type) {
                    ForEach(ContactType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
            }
            
            TextFieldView(title: $contact.title, placeholder: "Title")
            
            TextFieldView(title: $contact.value, placeholder: "Detail")
        }
    }
}

#Preview {
    @State @Previewable var contact = PharmacyContact.samples[0]
    
    ContactView(contact: $contact)
}

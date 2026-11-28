//
//  LabeledTextFieldView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct LabeledTextFieldView: View {
    @Binding var title: String
    let label: String
    let placeholder: String
    var capitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        TextFieldContainer(label: label, capitalization: capitalization) {
            TextFieldTintedPlaceholder(title: $title, placeholder: placeholder)
        }
    }
}

#Preview {
    @State @Previewable var title = ""
    
    LabeledTextFieldView(title: $title, label: "Full name", placeholder: "Enter you name")
        .padding()
}

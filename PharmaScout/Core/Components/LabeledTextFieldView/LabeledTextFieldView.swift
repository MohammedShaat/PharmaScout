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
    
    var body: some View {
        TextFieldContainer(label: label) {
            TextFieldTintedPlaceholder(title: $title, placeholder: placeholder)
        }
    }
}

#Preview {
    @State @Previewable var title = ""
    
    LabeledTextFieldView(title: $title, label: "Full name", placeholder: "Enter you name")
        .padding()
}

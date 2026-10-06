//
//  TextFieldView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var title: String
    let placeholder: String
    var capitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        TextFieldContainer(label: nil, capitalization: capitalization) {
            TextFieldTintedPlaceholder(title: $title, placeholder: placeholder)
        }
    }
}

#Preview {
    @State @Previewable var title = ""
    
    TextFieldView(title: $title, placeholder: "Enter you name")
        .padding()
}

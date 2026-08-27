//
//  TextFieldTintedPlaceholder.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct TextFieldTintedPlaceholder: View {
    @Binding var title: String
    let placeholder: String
    
    var body: some View {
        TextField(
            "",
            text: $title,
            prompt: Text(placeholder)
                .foregroundStyle(.theme.textSecondary)
        )
    }
}

#Preview {
    @State @Previewable var title = ""
    
    TextFieldTintedPlaceholder(title: $title, placeholder: "Enter text here")
        .padding()
}

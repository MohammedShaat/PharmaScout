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
    var axis: Axis = .horizontal
    var minHeight: Double = 0
    
    var body: some View {
        TextField(
            "",
            text: $title,
            prompt: Text(placeholder)
                .foregroundStyle(.theme.textSecondary),
            axis: axis
        )
        .frame(
            minHeight: minHeight,
            alignment: axis == .vertical ? .topLeading : .leading
        )
    }
}

#Preview {
    @State @Previewable var title = ""
    
    TextFieldTintedPlaceholder(title: $title, placeholder: "Enter text here")
        .padding()
}

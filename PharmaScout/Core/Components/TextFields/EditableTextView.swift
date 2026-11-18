//
//  EditableTextView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct EditableTextView: View {
    @Binding var text: String
    let placeholder: String
    let minCharacters: Int
    let minHeight: Double
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxSmall) {
            TextFieldView(title: $text, placeholder: placeholder, axis: .vertical, minHeight: minHeight)
            
            Text("Minimum \(minCharacters) characters")
                .font(.footnote)
                .foregroundStyle(.theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    @State @Previewable var text: String = ""
    
    EditableTextView(
        text: $text,
        placeholder: "Explain the reason of rejection",
        minCharacters: 50,
        minHeight: 150
    )
    .padding()
}

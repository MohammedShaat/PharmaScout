//
//  LabeledTextFieldView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct TextFieldContainer<TextField: View>: View {
    let label: String
    let capitalization: TextInputAutocapitalization
    let textField: TextField?
    
    init(
        label: String,
        capitalization: TextInputAutocapitalization = .never,
        @ViewBuilder textField: () -> TextField
    ) {
        self.label = label
        self.capitalization = capitalization
        self.textField = textField()
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(label)
                .font(.headline)
                .foregroundStyle(.theme.textLabel)
            
            textField
                .focused($isFocused)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                        .stroke(isFocused ? .theme.primary : .theme.border)
                )
                .foregroundStyle(.theme.primary)
                .fontWeight(.medium)
                .textInputAutocapitalization(capitalization)
        }
    }
}

#Preview {
    VStack(spacing: 60) {
        TextFieldContainer(label: "First name") {
            TextField("Entery your first name", text: .constant(""))
        }
        
        TextFieldContainer(label: "Second name") {
            TextField("Entery your second name", text: .constant(""))
        }
    }
    .padding()
}

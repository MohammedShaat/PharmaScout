//
//  LabeledTextFieldView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct LabeledSecureFieldView: View {
    @Binding var title: String
    let label: String
    var placeholder: String = "••••••••"
    @Binding var isInputHidden: Bool
    
    @State private var height: CGFloat = 0
    
    var body: some View {
        TextFieldContainer(label: label) {
            HStack {
                if isInputHidden {
                    tintedSecuredField
                } else {
                    TextFieldTintedPlaceholder(title: $title, placeholder: placeholder)
                }
                
                Text(isInputHidden ? "Show" : "Hide")
                    .font(.body)
                    .foregroundStyle(.theme.primary)
                    .fontWeight(.medium)
                    .clickable {
                        isInputHidden.toggle()
                    }
            }
            .readFrame { geo in
                if height == 0 {
                    height = geo.size.height
                }
            }
            .frame(height: height)
        }
    }
    
    private var tintedSecuredField: some View {
        SecureField(
            "",
            text: $title,
            prompt: Text(placeholder)
                .foregroundStyle(.theme.textSecondary)
        )
    }
}

#Preview {
    @State @Previewable var password = ""
    @State @Previewable var isInputHidden: Bool = true
    
    LabeledSecureFieldView(title: $password, label: "Password", placeholder: "Enter you pass", isInputHidden: $isInputHidden)
        .padding()
}

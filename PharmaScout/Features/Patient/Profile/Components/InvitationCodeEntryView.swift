//
//  InvitationCodeEntryView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct InvitationCodeEntryView: View {
    let title: String
    @Binding var code: String
    let codeLength: Int
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("The code must be \(codeLength) characters long.")
            }
            
            TextFieldView(title: $code, placeholder: "Enter the code here")
                .frame(maxWidth: 200)
        }
    }
}

#Preview {
    @State @Previewable var code: String = ""
    
    InvitationCodeEntryView(
        title: "Enter the code to send membership request",
        code: $code,
        codeLength: 8
    )
}

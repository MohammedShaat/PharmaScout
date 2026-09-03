//
//  AppleSginInButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import SwiftUI
import AuthenticationServices

struct AppleSginInButtonView: View {
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
          action?()
        } label: {
            AppleSignInButtonRepresentable(type: .continue, style: .black)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
        }
    }
}

private struct AppleSignInButtonRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: type, style: style)
        button.cornerRadius = DesignSystem.cornerRadius
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

#Preview {
    AppleSginInButtonView()
        .padding()
}
